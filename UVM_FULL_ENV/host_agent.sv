//host sequencer
typedef uvm_sequencer #(host_data) host_sequencer; 

//host agent
class host_agent extends uvm_agent;
  //virtual interface
  virtual host_if host_if_inst;
  //TLM analysis port
  uvm_analysis_port #(host_data) analysis_port;
  //host_seqeuncer handle
  host_sequencer h_seqr;
  //host_driver handle
  host_driver h_drv;
  
  //registering into factory
  `uvm_component_utils(host_agent)
  
  //constructor
  function new(string name = "host_agent", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    //get the host virtual interface 
    uvm_config_db#(virtual host_if)::get(this, "", "host_if", host_if_inst);
    //constructing host sequencer, driver handles
    h_seqr = host_sequencer::type_id::create("h_seqr", this);
    h_drv = host_driver::type_id::create("h_drv", this);
    //configuring the host interface to host driver
    uvm_config_db#(virtual host_if)::set(this, "h_drv", "host_if", host_if_inst);
    
  endfunction
  
  //connect_phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    //establishing connection between sequencer and driver
    h_drv.seq_item_port.connect(h_seqr.seq_item_export);
  endfunction
endclass
