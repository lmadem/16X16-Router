//TestCase3: The test is to send the stimulus packets of equal sizes by fixing the payload size

`include "base_test.sv"
`include "test_packet3.sv"

//test3 class
class test3 extends base_test;
  //test_packet3 handle
  test_packet3 pkt3;
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
    
    //construct object for pkt3 handle
    pkt3 = new;
    //declare number of packets to generate in generator
    pkt_count = 10;
    //construct environment objects and establish connections
    build();
    
    //Pass test_packet3 oject to Generator.
    //Handle assignment packet=test_packet3(b=d);
    for (bit [4:0] i=0; i<=15; i++) 
      env.gen.ref_pkt[i] = pkt3;
    
    //start the verification environment
    env.run();
    
    $display("[%0s] run ended at time=%0t",this.testname, $realtime);
  endtask
endclass
