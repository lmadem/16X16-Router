//In-Order Scoreboard
class scoreboard extends uvm_scoreboard;
  //uvm_in_order_class_class typed to packet class
  uvm_in_order_class_comparator #(packet) comp;
  
  //TLM analysis exports to bring in packets from iMonitor & oMonitor Components
  uvm_analysis_export #(packet) before_export;
  uvm_analysis_export #(packet) after_export;
  
  //registering into the factory
  `uvm_component_utils(scoreboard)
  
  //constructor
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    comp = uvm_in_order_class_comparator#(packet)::type_id::create("comp", this);
    before_export = comp.before_export;
    after_export = comp.after_export;
  endfunction
    
  //report phase
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    `uvm_info("[Scoreboard Report]", $sformatf("Comparator Matches = %0d, Mismatches = %0d", comp.m_matches, comp.m_mismatches), UVM_MEDIUM);
  endfunction
  
endclass
