//Interface
interface router_if(input bit clock);
  logic reset_n; //active low reset
  logic [15:0] din; //input data
  logic [15:0] frame_n; //must be active during whole input packet
  logic [15:0] valid_n; //input valid signal, indicates valid input data
  logic [15:0] dout; //output data
  logic [15:0] frameo_n; //active during whole output packet
  logic [15:0] valido_n; //output valid signal, indicates valid output data
  logic [15:0] busy_n; //tells input that connection is busy
  
  //clocking block for driver
  clocking cb@(posedge clock);
    //directions are w.r.t to testbench
    output din, frame_n, valid_n, reset_n;
    input dout, frameo_n, valido_n, busy_n;
  endclocking
  
  //clocking block for input monitor
  clocking cb_iMon@(posedge clock);
    input din, frame_n, valid_n, busy_n;
  endclocking
  
  
  //clocking block for output monitor
  clocking cb_oMon@(posedge clock);
    input dout, frameo_n, valido_n;
  endclocking
  
  //modport for specifying direction
  modport drv(clocking cb);
  modport iMon(clocking cb_iMon);
  modport oMon(clocking cb_oMon);
  modport dut(input clock, reset_n, din, frame_n, valid_n, output dout, frameo_n, valido_n, busy_n);
  
endinterface
