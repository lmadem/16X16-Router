//packet sequence
class packet_sequence extends uvm_sequence #(packet);
  //registering into factory
  `uvm_object_utils(packet_sequence)
  
  //constructor
  function new(string name = "packet_sequence");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    set_automatic_phase_objection(1);
  endfunction
  
  //body method
  task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    //if(starting_phase != null)
      //starting_phase.raise_objection(this);
    repeat(5)
      begin
        `uvm_do(req);
        $display("Generator");
        req.print();
      end
    //if(starting_phase != null)
      //starting_phase.drop_objection(this);
  endtask
endclass
