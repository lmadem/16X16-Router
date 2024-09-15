//reset transaction
class reset_transaction extends uvm_sequence_item;
  typedef enum {ASSERT, DEASSERT} kind_e;
  rand kind_e kind;
  rand int unsigned reset_cycles = 1;
  
  //registering into the factory
  `uvm_object_utils_begin(reset_transaction)
  `uvm_field_enum(kind_e, kind, UVM_ALL_ON)
  `uvm_field_int(reset_cycles, UVM_ALL_ON)
  `uvm_object_utils_end
  
  //constructor
  function new(string name = "reset_transaction");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
endclass


//reset sequence
class reset_sequence extends uvm_sequence #(reset_transaction);
  //registering into the factory
  `uvm_object_utils(reset_sequence)
  
  //constructor
  function new(string name = "reset_sequence");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    set_automatic_phase_objection(1);
  endfunction
  
  //body method
  task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    
    `uvm_do_with(req, {kind == ASSERT; reset_cycles == 2;});
    `uvm_do_with(req, {kind == DEASSERT; reset_cycles == 15;});
    
  endtask
  
  
  
endclass
