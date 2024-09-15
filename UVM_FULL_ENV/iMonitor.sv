//Input Monitor component
class iMonitor extends uvm_monitor;
  //virtual interface
  virtual router_if router_if_inst;
  //port id
  int port_id = -1;
  //destination address
  bit [3:0] da;
  //payload data
  bit [7:0] payload_data[$];
  //data to capture
  bit[7:0] data;
  //TLM analysis port
  uvm_analysis_port #(packet) analysis_port;
  
  //registering into the factory
  `uvm_component_utils_begin(iMonitor)
  `uvm_field_int(port_id, UVM_DEFAULT | UVM_DEC)
  `uvm_component_utils_end
  
  //constructor
  function new(string name = "iMonitor", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if(!uvm_config_db#(int)::get(this, "", "port_id", port_id))
      begin
        `uvm_fatal("iMON_CFG_ERR", "iMonitor port_id is not set");
      end
    if(!uvm_config_db#(virtual router_if)::get(this, "", "router_if", router_if_inst))
      begin
        `uvm_fatal("iMON_CFG_ERR", "iMonitor DUT interface is not set");
      end
    
    //create analysis port
    analysis_port = new("analysis_port", this);
  endfunction
  
  
  //run task
  virtual task run_phase(uvm_phase phase);
    packet pkt;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    forever
      begin
        pkt = packet::type_id::create("pkt", this);
        pkt.sa = this.port_id;
        collect_packet(pkt);
        //`uvm_info("Got Input Packet", {"\n", pkt.sprint()}, UVM_MEDIUM);
        analysis_port.write(pkt);
        //pkt.display("IMON");
      end
  endtask
  
 
  //collect packet method
  virtual task collect_packet(packet pkt);
    logic [7:0] data;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    //collecting da address
    @(negedge router_if_inst.cb_iMon.frame_n[port_id]);
    for(bit [2:0] i=0; i<4; i++)
      begin
        if(!router_if_inst.cb_iMon.frame_n[port_id])
          begin
            pkt.da[i] = router_if_inst.cb_iMon.din[port_id];
          end
        else
          begin
            `uvm_fatal("Header Error", $sformatf("@ Header cycle %0d, frame not zero", i));
          end
        @(router_if_inst.cb_iMon);
      end
    
    //collecting padding
    for(bit [2:0] i=0; i<5; i++)
      begin
        if(!router_if_inst.cb_iMon.frame_n[port_id])
          begin
            if(router_if_inst.cb_iMon.valid_n[port_id] && router_if_inst.cb_iMon.din[port_id])
              begin
                @(router_if_inst.cb_iMon);
                continue;
              end
            else
              begin
                `uvm_fatal("Header Error", $sformatf("@%0d valid zero or din zero", i));
              end
          end
        else
          begin
            `uvm_fatal("Header Error", "Frame not zero");
          end
      end
    
    
    //collecting payload
    forever
      begin
        for(bit [3:0] i=0; i<8; i=i)
          begin
            if(!router_if_inst.cb_iMon.valid_n[port_id]) 
              begin
                data[i++] = router_if_inst.cb_iMon.din[port_id];
                if(i == 8)
                  begin
                    pkt.payload.push_back(data);
                  end
              end
            if(router_if_inst.cb_iMon.frame_n[port_id]) begin
              if(i == 8) 
                begin
                  return;
                end
            end
            @(router_if_inst.cb_iMon);
          end  
      end
  endtask

endclass
