//new packet class to fix the destination address to port 3
class packet_da_3 extends packet;
  //registering into factory
  `uvm_object_utils(packet_da_3)
  //constraint to fix the da address
  constraint valid_da{
    da == 3;
  }
  
  //constructor
  function new(string name = "packet_da_3");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
endclass
