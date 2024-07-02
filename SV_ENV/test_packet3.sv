//test_packet3 class extends from base class packet
class test_packet3 extends packet;
  
  //constraint to override base class constraint to generate specific scenario
  constraint valid_payload{
    //payload size is fixed
    payload.size == 5;
  }

endclass
