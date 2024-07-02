`include "environment.sv"
//base_test class
class base_test;
  string testname; //unique identity
  int pkt_count; //packet count
  
  //virtual interfaces
  virtual router_if.drv vif;
  virtual router_if.iMon vif_mon_in;
  virtual router_if.oMon vif_mon_out;
  
  //environment handle
  environment env;
  
  //constructor
  function new(input virtual router_if.drv vif,
               input virtual router_if.iMon vif_mon_in,
               input virtual router_if.oMon vif_mon_out,
               input string testname);
    
    this.vif = vif;
    this.vif_mon_in = vif_mon_in;
    this.vif_mon_out = vif_mon_out;
    this.testname = testname;
    
  endfunction
   
  //extern methods
  extern virtual function void build();
  extern virtual task run();
endclass
 
//build function to build environment component
function void base_test::build();
  $display("[%0s] entered the build block at time=%0t", this.testname, $realtime);
  env = new("Environment", vif, vif_mon_in, vif_mon_out, this.pkt_count, this.testname);
  env.build();
  $display("[%0s] build ended", this.testname);
endfunction

//run task to build base_test component and run the env task
task base_test::run();
  $display("[%0s] run started at time=%0t",this.testname, $realtime);
  this.pkt_count = 16;
  build();
  env.run();
  $display("[%0s] run ended at time=%0t",this.testname, $realtime);
endtask

