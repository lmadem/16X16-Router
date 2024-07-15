//coverage component extends from uvm_subscriber typed to packet
class coverage extends uvm_subscriber #(packet);
  //registering into factory
  `uvm_component_utils(coverage)
  //number of packets received and sampled in coverage component
  bit [31:0] no_of_pkts_sampled;
  //variable to keep track of coverage score for ports
  real coverage_score_ports;
  //2D array to replicate coverage bins
  int unsigned arr[16][16]; 
  
  //covergroup for sa,da ports with sample method
  covergroup fcov_ports with function sample(packet pkt);
    coverpoint pkt.sa {option.auto_bin_max = 16;}
    coverpoint pkt.da {option.auto_bin_max = 16;}
    cross pkt.sa, pkt.da;
  endgroup
  
  //constructor
  function new(string name = "coverage", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    fcov_ports = new;
  endfunction
  
  //Implement custom write method to receive transaction from Monitor
  virtual function void write(T rhs);
    packet pkt;
    if(!$cast(pkt, rhs.clone))
      begin
         `uvm_fatal("COV", "Transaction object received is NULL in coverage component");
      end
    fcov_ports.sample(pkt);
    report_missed_bins(pkt);
    no_of_pkts_sampled++;
    coverage_score_ports = fcov_ports.get_coverage();
    `uvm_info("COV", $sformatf("Coverage=%0f", coverage_score_ports), UVM_NONE);
  endfunction
  
  //function to report missed bins in test1
  virtual function void report_missed_bins(packet pkt);
    // Iterate over possible sa and da values
    for(bit [4:0] i=0; i<16; i++) begin
      for(bit [4:0] j=0; j<16; j++) begin
        if(pkt.sa == i & pkt.da == j) 
          begin
            arr[i][j] = 1;
            break;
          end
      end
    end
  endfunction
  
  //report phase to display sampled packets and coverage score
  virtual function void report_phase(uvm_phase phase);
    string msg;
    bit [15:0] missed_bins_count;
    `uvm_info("[Coverage Report]", $sformatf("Total_pkts_sampled = %0d Coverage = %0f", no_of_pkts_sampled, coverage_score_ports), UVM_NONE);
    for(bit [4:0] i=0; i<16; i++) begin
      for(bit [4:0] j=0; j<16; j++) begin
        if(arr[i][j] != 1)
          begin
            missed_bins_count++;
            msg = $sformatf("Missed bins: sa = %0d, da = %0d, missed_bins_count = %0d", i, j, missed_bins_count);
            $display(msg);
          end
      end
    end
  endfunction
  
endclass

