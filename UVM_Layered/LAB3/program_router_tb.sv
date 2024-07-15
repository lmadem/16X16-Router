//program block
program automatic test;
  import uvm_pkg::*;
  `include "packet.sv"
  `include "packet_sequence.sv"
  `include "reset_sequence.sv"
  `include "sequencer.sv"
  `include "driver.sv"
  `include "reset_agent.sv"
  `include "input_agent.sv"
  `include "environment.sv"
  `include "base_test.sv"
  `include "test_da_3_inst.sv"
  `include "test_da_3_type.sv"
  `include "test_da_3_seq.sv"
  
  initial
    begin
      $timeformat(-9, 1, "ns", 10);
      run_test();
    end
endprogram
