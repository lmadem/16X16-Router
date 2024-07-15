//driver component
class driver extends uvm_driver #(packet);
  //virtual interface handle
  virtual router_if router_if_inst;
  //choosing the driver to only drive a choosen port with its default value -1, meant to configure the driver to only drive packets of matching source address(sa): if the incoming packet does not match the driver's port_id, that packet will be dropped; if port_id is not set -1, the driver will accept and drive all incoming packets
  int port_id = -1;
  //semaphore
  semaphore sem[];
  //registering into factory
  `uvm_component_utils_begin(driver)
  `uvm_field_int(port_id, UVM_DEFAULT+UVM_DEC)
  `uvm_component_utils_end
  
  //constructor
  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    sem = new[16];
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_config_db#(int)::get(this, "", "port_id", port_id);
    if(!(port_id inside {-1, [0:15]}))
      begin
        `uvm_fatal("DRV_CFGERR", $sformatf("port_id must be {-1, [0:15]}, not %0d!", port_id));
      end
    uvm_config_db#(virtual router_if)::get(this, "", "router_if", router_if_inst);
    if(router_if_inst == null)
      begin
        `uvm_fatal("DRV_CFGERR", "Interface for driver is not set");
      end
  endfunction
  
  //start of simulation phase
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    `uvm_info("DRV_CFG", $sformatf("port_id is %0d", port_id), UVM_MEDIUM);
  endfunction
  
  //pre_reset_phase
  virtual task pre_reset_phase(uvm_phase phase);
    super.pre_reset_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    phase.raise_objection(this);
    if(port_id == -1)
      begin
        router_if_inst.cb.frame_n <= 'x;
        router_if_inst.cb.valid_n <= 'x;
        router_if_inst.cb.din <= 'x;
      end
    else
      begin
        router_if_inst.cb.frame_n[port_id] <= 'x;
        router_if_inst.cb.valid_n[port_id] <= 'x;
        router_if_inst.cb.din[port_id] <= 'x;
      end
    phase.drop_objection(this);
  endtask
  
  
  //reset_phase
  virtual task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    phase.raise_objection(this);
    if(port_id == -1)
      begin
        router_if_inst.cb.frame_n <= '1;
        router_if_inst.cb.valid_n <= '1;
        router_if_inst.cb.din <= '0;
      end
    else
      begin
        router_if_inst.cb.frame_n <= '1;
        router_if_inst.cb.valid_n <= '1;
        router_if_inst.cb.din <= '0;
      end
    phase.drop_objection(this);
  endtask
  
  
  //run phase
  virtual task run_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    forever
      begin
        seq_item_port.get_next_item(req);
        if(port_id inside {-1, req.sa})
          begin
            this.sem[req.da].get(1);
            send();
            this.sem[req.da].put(1);
            //`uvm_info("DRV_RUN", {"\n", req.sprint()}, UVM_MEDIUM);
          end
        seq_item_port.item_done();
      end
  endtask
  
  //send task
  virtual task send();
    send_addr();
    send_pad();
    send_payload();
    repeat(5) @(router_if_inst.cb);
  endtask
  
  //sending destination address
  virtual task send_addr();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    router_if_inst.cb.frame_n[req.sa] <= 1'b0;
    for(bit [2:0] i=0; i<4; i++)
      begin
        router_if_inst.cb.din[req.sa] <= req.da[i];
        @(router_if_inst.cb);
      end
  endtask
  
  //sending padding bits
  virtual task send_pad();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    router_if_inst.cb.din[req.sa] <= 1'b1;
    router_if_inst.cb.valid_n[req.sa] <= 1'b1;
    repeat(5) @(router_if_inst.cb);
  endtask
  
  //sending payload
  virtual task send_payload();
    bit [7:0] payload[$];
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    foreach(req.payload[index])
      begin
        for(bit [3:0] i=0; i<8; i++)
          begin
            router_if_inst.cb.valid_n[req.sa] <= 1'b0;
            router_if_inst.cb.din[req.sa] <= req.payload[index][i];
            router_if_inst.cb.frame_n[req.sa] <= ((index == req.payload.size() - 1) && (i == 7));
            @(router_if_inst.cb);
          end
        router_if_inst.cb.valid_n[req.sa] <= 1'b1;
      end
  endtask
  
endclass
