//top module
module top();
  //clock declaration
  bit clk;
  
  //clock initialiazation
  initial clk = 0;
  //clock generation
  always #5 clk = ~clk;
  
  //Interface Instantiation
  router_if router_if_inst(clk);
  
  //DUT Instantiation
  router dut_inst(.clock(clk),
                  .reset_n(router_if_inst.reset_n),
                  .din(router_if_inst.din),
                  .frame_n(router_if_inst.frame_n),
                  .valid_n(router_if_inst.valid_n),
                  .dout(router_if_inst.dout),
                  .frameo_n(router_if_inst.frameo_n),
                  .valido_n(router_if_inst.valido_n),
                  .busy_n(router_if_inst.busy_n)
                 );
  
  //Program Block Instantiation
  testbench tb_inst(router_if_inst.drv, router_if_inst.iMon, router_if_inst.oMon);
  
  //dumping waveform
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, top.dut_inst);
    end
                  
  
  
endmodule
