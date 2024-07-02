//This test_packet2 serves testcase2, please see the testplan for more info

//test_packet2 class extends from base class packet
class test_packet2 extends packet;
  
  //constraint to override base class constraint to generate specific scenario
  constraint valid_da{
    //da should be fixed to a single destination port
    da == 5;
  }

endclass
