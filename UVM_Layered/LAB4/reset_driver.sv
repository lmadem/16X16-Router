//reset_driver component
class reset_driver extends uvm_driver #(reset_transaction);
  //virtual interface handle
  virtual router_if router_if_inst;
  
  //registering into factory
  `uvm_component_utils(reset_driver)
  
  //constructor
  function new(string name = "reset_driver", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_config_db#(virtual router_if)::get(this, "", "router_if", router_if_inst);
    if(router_if_inst == null)
      begin
        `uvm_fatal("RSTDRV_CFGERR", "Interface for reset_driver is not set");
      end
  endfunction
  
  
  //pre_reset_phase
  virtual task pre_reset_phase(uvm_phase phase);
    super.pre_reset_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    phase.raise_objection(this);
    router_if_inst.reset_n <= 'x;
    phase.drop_objection(this);
  endtask
  
  
  //reset_phase
  virtual task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    phase.raise_objection(this);
    router_if_inst.cb.reset_n <= 1;
    phase.drop_objection(this);
  endtask
  
  
  //run phase
  virtual task run_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    forever
      begin
        seq_item_port.get_next_item(req);
        $display("reset_driver");
        `uvm_info("reset_driver", {"\n", req.sprint()}, UVM_MEDIUM);
        send_reset();
        seq_item_port.item_done();
      end
  endtask
  
  //send_reset task
  virtual task send_reset();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if(req.kind == 0)
      begin
        router_if_inst.cb.reset_n <= req.kind;    
        repeat(req.reset_cycles) @(router_if_inst.cb);
      end
    else
      begin
        router_if_inst.cb.reset_n <= req.kind;
        repeat(req.reset_cycles) @(router_if_inst.cb);
      end
  endtask
endclass
