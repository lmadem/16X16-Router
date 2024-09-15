//Output Monitor component
class oMonitor extends uvm_monitor;
  //virtual interface
  virtual router_if router_if_inst;
  //port id
  int port_id = -1;
  //TLM analysis port
  uvm_analysis_port #(packet) analysis_port;
  
  //registering into the factory
  `uvm_component_utils_begin(oMonitor)
  `uvm_field_int(port_id, UVM_DEFAULT | UVM_DEC)
  `uvm_component_utils_end
  
  //constructor
  function new(string name = "oMonitor", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    
    if(!uvm_config_db#(int)::get(this, "", "port_id", port_id))
      begin
        `uvm_fatal("oMON_CFG_ERR", "oMonitor port_id is not set");
      end
    
    if(!uvm_config_db#(virtual router_if)::get(this, "", "router_if", router_if_inst))
      begin
        `uvm_fatal("oMON_CFG_ERR", "oMonitor DUT interface is not set");
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
        pkt.da = this.port_id;
        collect_packet(pkt);
        //`uvm_info("Got Output Packet", {"\n", pkt.sprint()}, UVM_MEDIUM);
        analysis_port.write(pkt);
        //pkt.display("OMON");
      end
  endtask
  
 
  //collect packet method
  virtual task collect_packet(packet pkt);
    logic [7:0] data;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    //collecting da address
    @(negedge router_if_inst.cb_oMon.valido_n[port_id]);
    //collecting payload
    forever
      begin
        for(bit [3:0] i=0; i<8; i=i)
          begin
            if(!router_if_inst.cb_oMon.valido_n[port_id]) 
              begin
                data[i++] = router_if_inst.cb_oMon.dout[port_id];
                if(i == 8)
                  begin
                    pkt.payload.push_back(data);
                  end
              end
            
            if(router_if_inst.cb_oMon.valido_n[port_id]) 
              begin
                return;
              end
            @(router_if_inst.cb_oMon);
          end  
      end
  endtask

endclass
