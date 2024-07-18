//TestCase2: Hit the 100% functional coverage for ports:{cross sa, da} with directed stimulus
//testcase2 extends from base_test
class testcase2 extends base_test;
  //registering into factory
  `uvm_component_utils(testcase2)
  
  //constructor
  function new(string name = "testcase2", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_config_db#(int)::set(this, "env.i_agent*.seqr", "item_count", 16);
    set_type_override_by_type(packet::get_type(), packet_sa_da::get_type());
  endfunction
  
  //start of simulation phase
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_top.print_topology();
    uvm_factory::get().print();
  endfunction
endclass
