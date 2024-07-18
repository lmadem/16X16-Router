//top module
module top;
  
  //clock declaration
  bit clock;
  
  //clock initialization
  initial clock = 0;
  
  //clock generation
  always #5 clock = !clock;
  
  //Interface Instanstiation
  router_if router_if_inst(clock);
  //Host Interface Instanstiation
  host_if host_if_inst(clock);
  //DUT Instanstiation
  router router_dut(router_if_inst, host_if_inst);
  
  
  //dumping waveform
  initial
    begin
      $dumpfile("dump.vcd");
      //$dumpvars(0, top.router_dut);
      $dumpvars(0, top);
    end
  
  
  
  
endmodule
