interface host_if(input clock);
  logic wr_n;
  logic [15:0] address;
  logic [15:0] data;
  
  clocking host_cb @(posedge clock);
    output wr_n;
    output address;
    input data;
  endclocking
  
  clocking host_mon @(posedge clock);
    input wr_n;
    input address;
    input data;
  endclocking
  
  modport dut(input clock, wr_n, address, inout data);
  
endinterface
