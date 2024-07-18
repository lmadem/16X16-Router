//package to create a sequence library
package packet_seq_lib_pkg;
import uvm_pkg::*;
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
    //payload.size() == 2;
  }
  
  //constructor
  function new(string name = "packet");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

endclass


//packet_seq_lib typed to packet transaction class
class packet_seq_lib extends uvm_sequence_library #(packet);
  //registering packet_seq_lib into factory
  `uvm_object_utils(packet_seq_lib)
  //registering packet_seq_lib into uvm_sequence_library
  `uvm_sequence_library_utils(packet_seq_lib)
  
  //constructor
  function new(string name = "packet_seq_lib");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    //the default child sequences registered in the sequence library are 10
    init_sequence_library();
  endfunction
endclass

endpackage
