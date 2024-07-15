//Transaction class
class packet extends uvm_sequence_item;
  rand bit [3:0] sa;
  rand bit [3:0] da;
  rand bit [7:0] payload[$];
  
  //registering into factory
  `uvm_object_utils_begin(packet)
  `uvm_field_int(sa, UVM_ALL_ON + UVM_NOCOMPARE);
  `uvm_field_int(da, UVM_ALL_ON);
  `uvm_field_queue_int(payload, UVM_ALL_ON);
  `uvm_object_utils_end
  
  //constraint
  constraint valid_payload{
    payload.size() inside {[1:10]};
  }
  
  //constructor
  function new(string name = "packet");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
endclass
