//TestCase1: The purpose of this testcase1 is to implement 100% functional coverage through constrained random stimulus

//Here the cover points are simple. coverpoint sa has 16 bins, coverpoint da has 16 bins since the design can support 16 source ports and 16 destination ports; cross sa, da; It covers 256 possible cases

`include "base_test.sv"
`include "test_packet1.sv"

//test1 class
class test1 extends base_test;
  //test_packet1 handle
  test_packet1 pkt1;
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
    
    //construct object for pkt1 handle
    pkt1 = new;
    //declare number of packets to generate in generator
    pkt_count = 16;
    //construct environment objects and establish connections
    build();
    
    //Pass test_packet1 oject to Generator.
    //Handle assignment packet=test_packet1(b=d);
    for (bit [4:0] i=0; i<=15; i++) 
      env.gen.ref_pkt[i] = pkt1;
    
    //start the verification environment
    env.run();
    
    $display("[%0s] run ended at time=%0t",this.testname, $realtime);
  endtask
endclass
