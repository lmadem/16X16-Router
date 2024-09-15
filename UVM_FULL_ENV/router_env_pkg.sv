package router_env_pkg;
//Import the UVM base class library
import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "packet.sv"
  `include "packet_sa_da.sv"
  `include "packet_fixed_payload.sv"
  `include "packet_variable_payload.sv"
  `include "packet_all_ports.sv"
  `include "packet_sa4_da4.sv"
  `include "packet_sequence.sv"  
  `include "reset_sequence.sv"
  `include "sequencer.sv"
  `include "driver.sv"
  `include "reset_driver.sv"
  `include "reset_agent.sv"
  `include "iMonitor.sv"
  `include "input_agent.sv"
  
  `include "oMonitor.sv"
  `include "output_agent.sv"

  //enable the lines(23-27) for testcase7 
  //`include "host_data.sv"
  //`include "host_sequence.sv"
  //`include "host_driver.sv"
  //`include "host_agent.sv"
  
  //`include "scoreboard.sv"
  `include "out_of_order_scoreboard.sv"
  `include "coverage.sv"
  `include "environment.sv"

endpackage
