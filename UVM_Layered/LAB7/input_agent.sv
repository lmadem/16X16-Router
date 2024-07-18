//Input agent
class input_agent extends uvm_agent;
  //virtual interface handle
  virtual router_if router_if_inst;
  //Agent's designated port
  int port_id;
  //packet_sequencer handle
  packet_sequencer seqr;
  //driver handle
  driver drv;
  //iMonitor handle
  iMonitor iMon;
  //TLM analysis port
  uvm_analysis_port #(packet) analysis_port;
  
  //registering into factory
  `uvm_component_utils_begin(input_agent)
  `uvm_field_int(port_id, UVM_DEFAULT | UVM_DEC);
  `uvm_component_utils_end
  
  
  //constructor
  function new(string name = "input_agent", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    
    //getting the port_id and virtual interface
    uvm_config_db#(int)::get(this, "", "port_id", port_id);
    uvm_config_db#(virtual router_if)::get(this, "", "router_if", router_if_inst);
    
    //constructing and configuring sequencer and driver components
    if(is_active == UVM_ACTIVE) begin
      seqr = packet_sequencer::type_id::create("seqr", this);
      drv = driver::type_id::create("drv", this);
      uvm_config_db#(int)::set(this, "drv", "port_id", port_id);
      uvm_config_db#(int)::set(this, "seqr", "port_id", port_id);
      uvm_config_db#(virtual router_if)::set(this, "drv", "router_if", router_if_inst);
    end
    
    //constructing & configuring iMonitor component
    iMon = iMonitor::type_id::create("iMon", this);
    uvm_config_db#(int)::set(this, "iMon", "port_id", port_id);
    uvm_config_db#(virtual router_if)::set(this, "iMon", "router_if", router_if_inst);
  endfunction
  
  //connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if(is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
    
    this.analysis_port = iMon.analysis_port;
  endfunction
  
endclass
