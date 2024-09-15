//packet_sa*_da* class extends from base class packet
class packet_sa4_da4 extends packet;
  
  //registering into factory
  `uvm_object_utils(packet_sa4_da4)
  
  //constructor
  function new(string name = "packet_sa4_da4");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //Here we are fixing the source address and destination address by using a constraint
  constraint valid_sa{
    sa == 4;
  }
  
  constraint valid_da{
    da == 4;
  }
  
  constraint valid{
    payload.size() inside {[2:5]};
  }
  


endclass
