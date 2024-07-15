//test_seq_lib_cfg component extends from base_test
class test_seq_lib_cfg extends base_test;
  //To configure the sequence library to execute n number of sequences and to set the execution type
  uvm_sequence_library_cfg seq_cfg;
  //registering into the factory
  `uvm_component_utils(test_seq_lib_cfg)
  
  //constructor
  function new(string name = "test_seq_lib_cfg", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //constructing the seq_cfg object to set UVM_SEQ_LIB_RAND mode and the max_random_count and min_random_count ro 1
    seq_cfg = new("seq_cfg", UVM_SEQ_LIB_RAND, 1, 1);
    uvm_config_db#(uvm_sequence_library_cfg)::set(this, "env.i_agent*.seqr.main_phase", "default_sequence.config", seq_cfg);
  endfunction
endclass
