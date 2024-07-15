//reset transaction
class reset_transaction extends uvm_sequence_item;
  typedef enum {ASSERT, DEASSERT} kind_e;
  rand kind_e kind;
  int unsigned reset_cycles = 15;
  
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
  function new(string name = "reset_transaction");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //body method
  task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    
    if(starting_phase != null)
      starting_phase.raise_objection(this);
    
    `uvm_info("RESET", "Executing reset", UVM_MEDIUM);
    
    if(starting_phase != null)
      starting_phase.drop_objection(this);
  endtask
  
  
  
endclass
