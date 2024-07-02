//coverage component
class coverage;
  packet pkt; //packet handle
  mbx mbx_iMon_cov[15:0]; //mailbox handle
  string name; //Unique identity
  string testname; //testname to identify test
  bit [31:0] no_of_pkts_collected; //no of packets sampled in coverage component
  int unsigned arr[16][16]; //2D array to replicate coverage bins
  
  real coverage_score1; //variable to store coverage score for test1
  real coverage_score4; //variable to store coverage score for test4
  
  //fcov1 to sample bins for test1
  covergroup fcov1 with function sample(packet pkt);
    
    coverpoint pkt.sa {option.auto_bin_max = 16;}
    coverpoint pkt.da {option.auto_bin_max = 16;}
    
    cross pkt.sa, pkt.da;
    
  endgroup
  
  //fcov4 to sample bins for test4
  covergroup fcov4 with function sample(packet pkt);
    
    coverpoint pkt.payload.size(){
      bins len_small = {[2:5]};
      bins len_medium = {[6:10]};
      bins len_large = {[11:15]};
      bins len_extralarge = {[16:20]};
      bins len_jumbo = {[20:$]};
    }

  endgroup
  
  
  //extern methods
  extern function new(string name = "coverage", input  mbx mbx_iMon_cov_arg[15:0], input string testname);
  extern virtual task run();
  extern virtual task get_pkt_and_sample(bit [3:0] sa);
  extern virtual function void report();
  extern virtual function void report_missed_bins(packet pkt);
endclass
    
//constructor
function coverage::new(string name = "coverage", input  mbx mbx_iMon_cov_arg[15:0], input string testname);
  this.name = name;
  this.testname = testname;
  this.mbx_iMon_cov = mbx_iMon_cov_arg;
  if(testname == "Test1")
    fcov1 = new;
  else if(testname == "Test4")
    fcov4 = new;
endfunction
    
//run task
task coverage::run();
  $display("[%0s] started at time=%0t", this.name, $realtime);
  fork
    get_pkt_and_sample(0);
    get_pkt_and_sample(1);
    get_pkt_and_sample(2);
    get_pkt_and_sample(3);
    get_pkt_and_sample(4);
    get_pkt_and_sample(5);
    get_pkt_and_sample(6);
    get_pkt_and_sample(7);
    get_pkt_and_sample(8);
    get_pkt_and_sample(9);
    get_pkt_and_sample(10);
    get_pkt_and_sample(11);
    get_pkt_and_sample(12);
    get_pkt_and_sample(13);
    get_pkt_and_sample(14);
    get_pkt_and_sample(15);
  join_none
  $display("[%0s] ended at time=%0t", this.name, $realtime);
endtask

//get_pkt_and_sample to sample the packets 
task coverage::get_pkt_and_sample(bit [3:0] sa);
  packet pkt;
  while(1)
    begin
      @(mbx_iMon_cov[sa].num);
      mbx_iMon_cov[sa].peek(pkt);
      no_of_pkts_collected++;
      if(testname == "Test1") begin
          fcov1.sample(pkt);
          //pkt.display("COV CHECK");
          //$display("[%0s] FCOV %0d Coverage = %0f packets_collected = %0d", this.name, sa, fcov.get_coverage(), this.no_of_pkts_collected);
          //$display("[%0s] sa = %0d da = %0d at time=%0t", this.name, pkt.sa, pkt.da, $realtime);
          report_missed_bins(pkt);
          coverage_score1 = fcov1.get_coverage();
          $display("[Coverage] Port %0d Coverage=%0f ",sa, fcov1.get_coverage());
          if(coverage_score1 == 100.00)
            begin
              $display("Hit %0f Coverage", coverage_score1);
              $display("Success");
              $display("Killing the [%s] from coverage component", testname);
              $finish;
            end
        end
      else if(testname == "Test4") begin
          fcov4.sample(pkt);
          //pkt.display("COV CHECK");
          coverage_score4 = fcov4.get_coverage();
          $display("[Coverage] Port %0d Coverage=%0f ",sa, fcov4.get_coverage());
          if(coverage_score4 == 100.00)
            begin
              $display("Hit %0f Coverage", coverage_score4);
              $display("Success");
              //$display("Killing the [%s] from coverage component", testname);
              //$finish;
            end
        end
    end
endtask
    
//function to report missed bins in test1
function void coverage::report_missed_bins(packet pkt);
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
    
//report function to keep a track of collected coverage 
function void coverage::report();
  string msg;
  bit [15:0] missed_bins_count;
  
  if(testname == "Test1") begin
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
    coverage_score1 = fcov1.get_coverage();
    $display("********* Functional Coverage **********");
    $display("** coverage_score=%0f ",coverage_score1);
    $display("**************************************");
  end
  
  else if(testname == "Test4") begin
      coverage_score4 = fcov4.get_coverage();
      $display("********* Functional Coverage **********");
      $display("** coverage_score = %0f ",coverage_score4);
      $display("**************************************");
    end
endfunction

