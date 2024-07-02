//TestCase2: The test is to send the stimulus to a single destination port

//Example : Sa* -> Da5

`include "base_test.sv"
`include "test_packet2.sv"

//test2 class
class test2 extends base_test;
  //test_packet2 handle
  test_packet2 pkt2;
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
    
    //construct object for pkt2 handle
    pkt2 = new;
    //declare number of packets to generate in generator
    pkt_count = 10;
    //construct environment objects and establish connections
    build();
    
    //Pass test_packet1 oject to Generator.
    //Handle assignment packet=test_packet2(b=d);
    for (bit [4:0] i=0; i<=15; i++) 
      env.gen.ref_pkt[i] = pkt2;
    
    //start the verification environment
    env.run();
    
    $display("[%0s] run ended at time=%0t",this.testname, $realtime);
  endtask
endclass
