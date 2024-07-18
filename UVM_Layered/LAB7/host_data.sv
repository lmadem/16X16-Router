//host_data extends from uvm_sequence_item;
class host_data extends uvm_sequence_item;
  //config registers mode
  typedef enum {READ, WRITE} kind_e;
  rand kind_e kind;
  rand bit [15:0] addr;
  rand bit [15:0] data;
  
  //registering into factory
  `uvm_object_utils_begin(host_data)
  `uvm_field_enum(kind_e, kind, UVM_ALL_ON)
  `uvm_field_int(addr, UVM_ALL_ON)
  `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end
  
  //constructor
  function new(string name = "host_data");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
endclass
