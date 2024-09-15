//TestCase6 : The test is to send the stimulus from ports SA0 -> DA0, SA1 -> DA1, SA2 -> DA2, SA3 -> DA3, and SA4 -> DA4 parallely and so on

//testcase6 extends from base_test
class testcase6 extends base_test;
  //registering into factory
  `uvm_component_utils(testcase6)
  
  //constructor
  function new(string name = "testcase6", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_config_db#(int)::set(this, "env.i_agent*.seqr", "item_count", 16);
    set_type_override_by_type(packet::get_type(), packet_all_ports::get_type());
  endfunction
  
  //start of simulation phase
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_top.print_topology();
    uvm_factory::get().print();
  endfunction
endclass
