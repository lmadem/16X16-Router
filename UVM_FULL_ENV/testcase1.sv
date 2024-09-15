//TestCase1: The purpose of this testcase1 is to implement 100% functional coverage through constrained random stimulus

//There are 16 input ports and 16 output ports and here the cover points are simple. coverpoint sa has 16 bins, coverpoint da has 16 bins since the design can support 16 source ports and 16 destination ports; cross sa, da; It covers 256 possible cases

//testcase1 component
class testcase1 extends base_test;
  //registering into factory
  `uvm_component_utils(testcase1)
 
  
  //constructor
  function new(string name = "testcase1", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_config_db#(int)::set(this, "env.i_agent*.seqr", "item_count", 105);
  endfunction
  
  //start of simulation phase
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_top.print_topology();
    uvm_factory::get().print();
  endfunction

endclass
