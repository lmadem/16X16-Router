//reset sequencer
typedef uvm_sequencer #(reset_transaction) reset_sequencer; 
//reset agent component
class reset_agent extends uvm_agent;
  //reset_sequencer handle
  reset_sequencer rst_seqr;
  //reset_driver handle
  reset_driver rst_drv;
  //registering into the factory
  `uvm_component_utils(reset_agent)
  
  //constructor
  function new(string name = "reset_agent", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    rst_seqr = reset_sequencer::type_id::create("rst_seqr", this);
    rst_drv = reset_driver::type_id::create("rst_drv", this);
  endfunction
  
  //connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    rst_drv.seq_item_port.connect(rst_seqr.seq_item_export);
  endfunction
  
endclass

