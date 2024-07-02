//test_packet4 class extends from base class packet
class test_packet4 extends packet;
  
  //constraint to override base class constraint to generate specific scenario
  constraint valid_payload{
    //payload size is variable
    payload.size inside {[2:25]};
  }

endclass
