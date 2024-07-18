//Output agent
class output_agent extends uvm_agent;
  //virtual interface handle
  virtual router_if router_if_inst;
  //Agent's designated port
  int port_id;
  //oMonitor handle
  oMonitor oMon;
  //TLM analysis port
  uvm_analysis_port #(packet) analysis_port;
  
  //registering into factory
  `uvm_component_utils_begin(output_agent)
  `uvm_field_int(port_id, UVM_DEFAULT | UVM_DEC);
  `uvm_component_utils_end
  
  
  //constructor
  function new(string name = "output_agent", uvm_component parent);
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
    
    //constructing and configuring oMonitor component
    oMon = oMonitor::type_id::create("oMon", this);
    uvm_config_db#(int)::set(this, "oMon", "port_id", port_id);
    uvm_config_db#(virtual router_if)::set(this, "oMon", "router_if", router_if_inst);
   
  endfunction
  
  //connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);    
    this.analysis_port = oMon.analysis_port;
  endfunction
  
endclass
