//Testcase8 : The test is to send the stimulus to a single destination port from a single source port

//Example : Sa4 -> Da4

//testcase8 extends from base_test
class testcase8 extends base_test;
  //registering into factory
  `uvm_component_utils(testcase8)
  
  //match Port ID
  int match_port_id = -1;
  
  //constructor
  function new(string name = "testcase8", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_config_db#(int)::set(this, "env.i_agent*.seqr", "item_count", 5);
    uvm_config_db#(int)::set(this, "env.i_agent*.seqr", "match_id", match_port_id);
    set_type_override_by_type(packet::get_type(), packet_sa4_da4::get_type());
  endfunction
  
  //start of simulation phase
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_top.print_topology();
    uvm_factory::get().print();
  endfunction
endclass
