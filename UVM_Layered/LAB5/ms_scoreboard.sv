//custom in_order_class_comparator for multi-stream scoreboard
`uvm_analysis_imp_decl(_before)
`uvm_analysis_imp_decl(_after)
//scoreboard component
class scoreboard extends uvm_scoreboard;
  //uvm_in_order_class_comparators typed to packet class
  uvm_in_order_class_comparator #(packet) comp[16];
  
  //TLM analysis ports to bring in packets from iMonitor & oMonitor Components
  uvm_analysis_imp_before #(packet, scoreboard) before_export;
  uvm_analysis_imp_after #(packet, scoreboard) after_export;
  
  //registering into the factory
  `uvm_component_utils(scoreboard)
  
  //constructor
  function new(string name = "ms_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    foreach(comp[i])
      comp[i] = new($sformatf("comparator_%0d", i), this);
    before_export = new("before_export", this);
    after_export = new("after_export", this);
  endfunction
  
  //write_before function
  virtual function void write_before(packet pkt);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    comp[pkt.da].before_export.write(pkt);
  endfunction
  
  //write_after function
  virtual function void write_after(packet pkt);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    comp[pkt.da].after_export.write(pkt);
  endfunction
    
  //report phase
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    foreach(comp[i])
      begin
        `uvm_info("[Scoreboard Report]", $sformatf("Comparator[%0d] Matches = %0d, Mismatches = %0d", i, comp[i].m_matches, comp[i].m_mismatches), UVM_MEDIUM);
      end
  endfunction
  
endclass
