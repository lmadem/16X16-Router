//host interface for configuring the dut registers
interface host_if(input clock);
  logic wr_n;
  logic [15:0] address;
  logic [15:0] data;
  
  clocking cb_host_drv @(posedge clock);
    output wr_n;
    output address;
    output data;
  endclocking
  
  clocking cb_host_mon @(posedge clock);
    input wr_n;
    input address;
    input data;
  endclocking
  
  modport dut(input clock, wr_n, address, inout data);
  modport drv(clocking cb_host_drv);
  modport mon(clocking cb_host_mon);
  
  
endinterface
