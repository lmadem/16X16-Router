//TestCase4: The test is to send the stimulus packets of variable-sizes and hit the coverage

`include "base_test.sv"
`include "test_packet4.sv"

//test4 class
class test4 extends base_test;
  //test_packet4 handle
  test_packet4 pkt4;
  //used to identify the testcase
  string testname; 
  
  //contructor - to establish connections
  function new(input virtual router_if.drv vif,
               input virtual router_if.iMon vif_mon_in,
               input virtual router_if.oMon vif_mon_out,
               input string testname);
    super.new(vif, vif_mon_in, vif_mon_out, testname);
    this.testname = testname;
    
  endfunction
  
  //run task to start verification environment
  virtual task run();
    $display("[%0s] run started at time=%0t",this.testname, $realtime);
    
    //construct object for pkt4 handle
    pkt4 = new;
    //declare number of packets to generate in generator
    pkt_count = 2;
    //construct environment objects and establish connections
    build();
    
    //Pass test_packet4 oject to Generator.
    //Handle assignment packet=test_packet4(b=d);
    for (bit [4:0] i=0; i<=15; i++) 
      env.gen.ref_pkt[i] = pkt4;
    
    //start the verification environment
    env.run();
    
    $display("[%0s] run ended at time=%0t",this.testname, $realtime);
  endtask
endclass
