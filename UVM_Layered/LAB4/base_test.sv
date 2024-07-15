//base test component
class base_test extends uvm_test;
  //registering into factory
  `uvm_component_utils(base_test)
  
  //environment handle
  environment env;
  
  //constructor
  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    env = environment::type_id::create("env", this);
    uvm_config_db#(virtual router_if)::set(this, "env.i_agent.drv", "router_if", top.router_if_inst);
    uvm_config_db#(virtual router_if)::set(this, "env.r_agent.rst_drv", "router_if", top.router_if_inst);
  endfunction
  
  //start of simulation phase
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_top.print_topology();
    uvm_factory::get().print();
  endfunction
endclass
