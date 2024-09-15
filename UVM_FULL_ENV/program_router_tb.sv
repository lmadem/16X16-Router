//Include router verification environment package
`include "router_env_pkg.sv"

//`include "packet_seq_lib_pkg.sv"
//program block
program automatic test;
  //Import the UVM base class library
  import uvm_pkg::*;
  
  //Import router verification environment from router_env_pkg
  import router_env_pkg::*;
  
  `include "base_test.sv"
  `include "testcase1.sv"
  `include "testcase2.sv"
  `include "testcase3.sv"
  `include "testcase4.sv"
  `include "testcase5.sv"
  `include "testcase6.sv"
  //`include "testcase7.sv"
  `include "testcase8.sv"
  
  initial
    begin
      $timeformat(-9,1,"ns",10);
      run_test();
    end
  
  
endprogram
