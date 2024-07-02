`include "router_pkg.sv"

//program block
program automatic testbench(router_if.drv vif, router_if.iMon vif_mon_in, router_if.oMon vif_mon_out);
  import router_pkg::*;
  //Include test classes
  //`include "base_test.sv"
  //`include "test1.sv"
  //`include "test2.sv"
  //`include "test3.sv"
  //`include "test4.sv"
  `include "test5.sv"
  
  //test component handles
  //base_test test;
  //test1 t1;
  //test2 t2;
  //test3 t3;
  //test4 t4;
  test5 t5;
  
  //testname to identify the testcase name
  string testname;
  //Pass argument "Base_Test" to run "base_test.sv"
  //Pass argument "Test1" to run "test1.sv"
  //Pass argument "Test2" to run "test2.sv"
  //Pass argument "Test3" to run "test3.sv"
  //Pass argument "Test4" to run "test4.sv"
  //Pass argument "Test5" to run "test5.sv"
  initial
    begin
      //test = new(vif, vif_mon_in, vif_mon_out, "Base_Test");
      //t1 = new(vif, vif_mon_in, vif_mon_out, "Test1");
      t5 = new(vif, vif_mon_in, vif_mon_out, "Test5");
      //test.run();
      t5.run();
    end

  
endprogram
