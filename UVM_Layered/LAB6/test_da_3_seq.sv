//test_da_3_seq extends from base_test
class test_da_3_seq extends base_test;
  //registering into factory
  `uvm_component_utils(test_da_3_seq)
  
  //constructor
  function new(string name = "test_da_3_seq", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    //Using OOPS inheritance to set the packet da to 3 is one way, we can acheive the same by setting the sequence configuration here
    uvm_config_db#(bit [15:0])::set(this,"env.i_agent*.seqr", "da_enable", 16'h0008);
    uvm_config_db#(int)::set(this, "env.i_agent*.seqr", "item_count", 20);
  endfunction
  
  //start of simulation phase
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_top.print_topology();
    uvm_factory::get().print();
  endfunction
  
endclass
