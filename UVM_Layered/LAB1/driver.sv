//driver component
class driver extends uvm_driver #(packet);
  //registering into factory
  `uvm_component_utils(driver)
  
  //constructor
  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //run phase
  virtual task run_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    forever
      begin
        seq_item_port.get_next_item(req);
        $display("Driver");
        req.print();
        seq_item_port.item_done();
      end
  endtask
endclass
