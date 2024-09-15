//packet_variable_payload class extends from base class packet
class packet_variable_payload extends packet;
  
  //registering into factory
  `uvm_object_utils(packet_variable_payload)
  
  //constructor
  function new(string name = "packet_variable_payload");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //Here we are fixing the payload size by using a constraint
  constraint valid_payload{
    payload.size() inside {[10:20]};
  }
  


endclass
