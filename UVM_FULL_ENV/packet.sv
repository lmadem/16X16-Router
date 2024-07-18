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
  
  //compare function
  function bit compare(packet pkt2cmp, ref string message);
    if(this.payload.size() != pkt2cmp.payload.size())
      begin
        message = "payload size mismatch:\n";
        message = {message, $sformatf("Expected_payload.size = %0d Received_payload.size = %0d\n", this.payload.size(), pkt2cmp.payload.size())};
        return(0);
      end
    if(this.payload == pkt2cmp.payload)
      begin
        message = "Successfully Compared";
        //$display(this.payload);
        //$display(pkt2cmp.payload);
        //$display("Successfully Compared");
        return(1);
      end
    else
      begin
        message ="Payload Content Mismatch:\n";
        message = {message,$sformatf("Packet Sent: %p\n Pkt Received: %p",this.payload, pkt2cmp.payload)};
        return(0);
      end
  endfunction

  //post-randomize function
  function void post_randomize();
    randomize_with_combinations();
  endfunction
  
  //randomize_with_combinations function
  virtual function void randomize_with_combinations();
    //for future use
  endfunction
  
  //Display function
  function void display(string prefix = "DISPLAY");
    $display("[packet:%s] time = %0t sa = %0d, da = %0d", prefix, $realtime, sa, da);
    foreach(payload[index])
      $display("[packet:%s] time = %0t payload[%0d] = %0h", prefix, $realtime, index, payload[index]);
  endfunction


endclass
