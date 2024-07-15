`ifndef PACKET_DA_3_SV
`define PACKET_DA_3_SV
`include "packet_da_3.sv"
`endif
//test_da_3_type extends from base_test
class test_da_3_type extends base_test;
  //registering into factory
  `uvm_component_utils(test_da_3_type)
  
  //constructor
  function new(string name = "test_da_3_type", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    set_type_override_by_type(packet::get_type(), packet_da_3::get_type());
  endfunction
  
  //start of simulation phase
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_top.print_topology();
    uvm_factory::get().print();
  endfunction
endclass
