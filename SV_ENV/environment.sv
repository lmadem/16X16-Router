//environment class
class environment;
  string name; //Identifier for component
  string testname; //testname
  int packet_count; //packet count
  //virtual interfaces
  virtual router_if.drv vif;
  virtual router_if.iMon vif_mon_in;
  virtual router_if.oMon vif_mon_out;
  
  //mailbox handles
  mbx mbx_gen[15:0];
  mbx mbx_iMon[15:0];
  mbx mbx_oMon[15:0];
  
  //component handles
  generator gen;
  driver drvr[];
  iMonitor iMon[];
  oMonitor oMon[];
  semaphore sem[];
  scoreboard scb;
  coverage cov;
  
  //will be used to enable/disable report function
  bit env_disable_report;
  //will be used to enable/disable test termination
  bit env_disable_EOT;
  
  //extern methods
  extern function new(string name = "environment", input virtual router_if.drv vif, virtual router_if.iMon vif_mon_in, virtual router_if.oMon vif_mon_out, int packet_count, string testname);
  extern virtual function void build();  
  extern virtual task run();
  extern virtual task report();   
endclass
    
//constructor
function environment::new(string name = "environment", input virtual router_if.drv vif, virtual router_if.iMon vif_mon_in, virtual router_if.oMon vif_mon_out, int packet_count, string testname);
  this.name = name;
  this.vif = vif;
  this.vif_mon_in = vif_mon_in;
  this.vif_mon_out = vif_mon_out;
  this.packet_count = packet_count;
  this.testname = testname;
  $display("Check : %0s", testname);
endfunction

    
//build function
function void environment::build();
  //packet_count = 10;
  for(bit [4:0] i=0; i<=15; i++)
    begin
      mbx_gen[i] = new(1);
      mbx_iMon[i] = new(1);
      mbx_oMon[i] = new(1);
    end
  
  gen = new("Generator", mbx_gen[15:0], this.packet_count);
  drvr = new[16];
  iMon = new[16];
  oMon = new[16];
  sem = new[16];
  foreach(sem[i])
    sem[i] = new(1);
  for(int i=0; i<drvr.size(); i++)
    drvr[i] = new("Driver", mbx_gen[i], vif, sem);
  for(int i=0; i<iMon.size(); i++)
    iMon[i] = new("iMonitor", vif_mon_in, mbx_iMon[i]);
  for(int i=0; i<oMon.size(); i++)
    oMon[i] = new("oMonitor", vif_mon_out, mbx_oMon[i]);
  
  scb = new("Scoreboard", mbx_iMon[15:0], mbx_oMon[15:0]); 
  cov = new("Coverage", mbx_iMon[15:0], this.testname);
  
endfunction
    
    
//start task
task environment::run();
  $display("[%s] run started at time=%0t", this.name,$realtime); 
  fork
    gen.run();
    for(bit [4:0] i=0; i<=15 ; i++)
      fork
        automatic bit [4:0] k = i;
        drvr[k].run();
        iMon[k].run();
        oMon[k].run();
      join_none
    cov.run();
    scb.run();
  join_any
  
  if(testname == "Base_Test" && !env_disable_EOT)
    wait(scb.total_output_packets.sum() == (16 * packet_count));//Base_Test termination
  if(testname == "Test1" && !env_disable_EOT)
    wait(scb.total_output_packets.sum() == (16 * packet_count));//Test1 termination
  if(testname == "Test2" && !env_disable_EOT)
    wait(scb.total_output_packets.sum() == (16 * packet_count));//Test2 termination
  if(testname == "Test3" && !env_disable_EOT)
    wait(scb.total_output_packets.sum() == (16 * packet_count));//Test3 termination
  if(testname == "Test4" && !env_disable_EOT)
    wait(scb.total_output_packets.sum() == (16 * packet_count));//Test4 termination
  if(testname == "Test5" && !env_disable_EOT)
    wait(scb.total_output_packets.sum() == (16 * packet_count));//Test5 termination  
  repeat(20) @(vif.cb); //drain time
  
  //Print results of all components
  if(!env_disable_report) 
    report();
  $display("[%s] run ended at time=%t", this.name,$realtime); 
endtask
    
//wait_for_end task
task environment::report();
  gen.report();
  for(bit [4:0] i=0; i<=15; i++) begin
    drvr[i].report();
  end
  
  for(bit [4:0] i=0; i<=15; i++) begin
    iMon[i].report();
  end
  
  for(bit [4:0] i=0; i<=15; i++) begin
    oMon[i].report();
  end
  
  //scb.report();
  cov.report();
  
  $display("\n*******************************"); 
  //Check the results and print test Passed or Failed
  case(testname)
    
    "Base_Test" : if(scb.m_mismatches == 0 && (16 * packet_count == scb.total_output_packets.sum()))
      begin
        $display("***********%s PASSED************", testname); 
        $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
      end
    else
      begin
        $display("***********%s PASSED************", testname); 
        $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
      end
    
    "Test1" : if(scb.m_mismatches == 0 && (16 * packet_count == scb.total_output_packets.sum()))
      begin
        $display("***********%s PASSED************", testname); 
        $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
      end
    else
      begin
        $display("***********%s PASSED************", testname); 
        $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
      end
    
    "Test2" : if(scb.m_mismatches == 0 && (16 * packet_count == scb.total_output_packets.sum()))
      begin
        $display("***********%s PASSED************", testname); 
        $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
      end
    else
      begin
        $display("***********%s PASSED************", testname); 
        $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
      end
    
    "Test3" : if(scb.m_mismatches == 0 && (16 * packet_count == scb.total_output_packets.sum()))
      begin
        $display("***********%s PASSED************", testname); 
        $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
      end
    else
      begin
        $display("***********%s PASSED************", testname); 
        $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
      end
    
    "Test4" : if(scb.m_mismatches == 0 && (16 * packet_count == scb.total_output_packets.sum()))
      begin
        $display("***********%s PASSED************", testname); 
        $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
      end
    else
      begin
        $display("***********%s PASSED************", testname); 
        $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
      end
    
    "Test5" : if(scb.m_mismatches == 0 && (16 * packet_count == scb.total_output_packets.sum()))
      begin
        $display("***********%s PASSED************", testname); 
        $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
      end
    else
      begin
        $display("***********%s PASSED************", testname); 
        $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
      end
    
    default : begin
      $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
    end
    
  endcase
  $display("*************************\n "); 
  $display("[Environment] ******** Report ended******** \n"); 

  
endtask
