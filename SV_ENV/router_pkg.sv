
package router_pkg;
  int packet_count;
  int TRACE_ON = 0;
  
  `include "header.h"
  `include "packet.sv"
  `include "generator.sv"
  `include "driver.sv"
  `include "iMonitor.sv"
  `include "oMonitor.sv"
  `include "scoreboard.sv"
  `include "coverage.sv"
  `include "environment.sv"
endpackage:router_pkg
