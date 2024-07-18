//packet_fixed_payload class extends from base class packet
class packet_fixed_payload extends packet;
  
  //registering into factory
  `uvm_object_utils(packet_fixed_payload)
  
  //constructor
  function new(string name = "packet_fixed_payload");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //Here we are fixing the payload size by using a constraint
  constraint valid{
    payload.size() == 5;
  }
  


endclass
