//program block
program automatic test;
  import uvm_pkg::*;
  `include "packet.sv"
  `include "packet_sequence.sv"
  `include "sequencer.sv"
  `include "driver.sv"
  `include "input_agent.sv"
  `include "environment.sv"
  `include "base_test.sv"
  
  initial
    begin
      $timeformat(-9, 1, "ns", 10);
      run_test();
    end
endprogram
