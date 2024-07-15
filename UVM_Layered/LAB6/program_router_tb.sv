`include "packet_seq_lib_pkg.sv"
//program block
program automatic test;
  import uvm_pkg::*;
  //`include "packet.sv"
  import packet_seq_lib_pkg::*;
  `include "packet_sequence.sv"
  `include "sequencer.sv"
  `include "driver.sv"
  
  `include "reset_sequence.sv"
  `include "reset_driver.sv"
  `include "reset_agent.sv"
  `include "iMonitor.sv"
  `include "input_agent.sv"
  
  `include "oMonitor.sv"
  `include "output_agent.sv"
  
  //`include "scoreboard.sv"
  `include "ms_scoreboard.sv"
  `include "coverage.sv"
  `include "environment.sv"
  `include "base_test.sv"
  `include "test_da_3_inst.sv"
  `include "test_da_3_type.sv"
  `include "test_da_3_seq.sv"
  `include "test_seq_lib_cfg.sv"
  
  
  initial
    begin
      $timeformat(-9,1,"ns",10);
      run_test();
    end
  
  
endprogram
