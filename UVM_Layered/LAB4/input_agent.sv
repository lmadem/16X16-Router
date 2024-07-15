//Input agent
class input_agent extends uvm_agent;
  //registering into factory
  `uvm_component_utils(input_agent)
  //packet_sequencer handle
  packet_sequencer seqr;
  //driver handle
  driver drv;
  
  //constructor
  function new(string name = "input_agent", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    seqr = packet_sequencer::type_id::create("seqr", this);
    drv = driver::type_id::create("drv", this);
  endfunction
  
  //connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
endclass
