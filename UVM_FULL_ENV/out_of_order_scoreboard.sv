//scoreboard component
class scoreboard #(type T = packet) extends uvm_scoreboard;
  typedef scoreboard #(T) scb_type;
  
  `uvm_component_param_utils(scb_type);
  
  //The $typename system function returns a string that represents the resolved type of its argument
  const static string type_name = $sformatf("scoreboard#(%0s)", $typename(T));
  
  virtual function string get_type_name();
    return type_name;
  endfunction
  
  `uvm_analysis_imp_decl(_before)
  `uvm_analysis_imp_decl(_after)
  
  //TLM analysis ports to bring in packets from iMonitor & oMonitor Components
  uvm_analysis_imp_before #(T, scoreboard) before_export;
  uvm_analysis_imp_after #(T, scoreboard) after_export;
  
  T q_in[$];
  bit [31:0] m_matches, m_mismatches;
  bit [31:0] no_of_pkts_recvd;
  
 
  //constructor
  function new(string name = "ms_scoreboard", uvm_component parent=null);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    before_export = new("before_export", this);
    after_export = new("after_export", this);
  endfunction
  
  //write_before function
  virtual function void write_before(T pkt);
    T pkt_in;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    $cast(pkt_in, pkt.clone());
    q_in.push_back(pkt_in);
  endfunction
  
  //write_after function
  virtual function void write_after(T pkt);
    T ref_pkt;
    int get_index[$];
    int index;
    bit done;
    string message;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    get_index = q_in.find_first_index() with (item.da == pkt.da);
    no_of_pkts_recvd++;
    foreach(get_index[i]) begin
      index = get_index[i];
      ref_pkt = q_in[index];
      if(ref_pkt.compare(pkt, message)) begin
        m_matches++;
        q_in.delete(index);
        `uvm_info("SCB_MATCH", $sformatf("Packet %0d Matched", no_of_pkts_recvd), UVM_NONE);
        done = 1;
        break;
      end
      else
        begin
          done = 0;
        end
    end
    if(!done)
      begin
        m_mismatches++;
        `uvm_error("SCB_NOMATCH", $sformatf("*****No matching packet found for the pkt_id=%0d*****", no_of_pkts_recvd));
        pkt.display("Received");
        done = 0;
      end
  endfunction
  
    
  //report phase
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    `uvm_info("SCB", $sformatf("Scoreboard completed with matches=%0d mismatches=%0d", m_matches, m_mismatches), UVM_NONE);
  endfunction
  
endclass
