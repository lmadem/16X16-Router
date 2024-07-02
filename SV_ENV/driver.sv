//driver class
class driver;
  //virtual interface handle
  virtual router_if.drv vif;
  //mailbox instance
  mbx mbx_gen_drv;
  
  //semaphore handle - to make sure that no other destination ports are driven at the same time from driver
  semaphore sem[];
  
  static bit [3:0] id; //used for incrementing port_id and persistent throughout the simulation
  bit [3:0] port_id; //sa port_id
  
  bit [31:0] no_of_pkts_received; //no of packets received from generator
  bit [31:0] pkt_count; //numbers of packets driven
   
  string name; //Unique indentification for driver component
  packet pkt; //packet handle
  
  //extern methods
  extern function new(string name = "driver", input mbx mbx_gen_drv_arg, input virtual router_if.drv vif_arg, semaphore sem[]);
  extern virtual task run();
  extern virtual task drive(packet pkt);
  extern virtual task drive_preset(packet pkt);
  extern virtual task drive_reset(packet pkt);
  extern virtual task drive_stimulus(packet pkt);
  extern virtual task send_addr(packet pkt);
  extern virtual task send_pad(packet pkt);
  extern virtual task send_payload(packet pkt);
  extern function void report();

endclass
    
//constructor : to establish connections    
function driver::new(string name = "driver", input mbx mbx_gen_drv_arg, input virtual router_if.drv vif_arg, semaphore sem[]);
  this.name = name;
  this.mbx_gen_drv = mbx_gen_drv_arg;
  this.vif = vif_arg;
  this.sem = sem;
  this.id++;
  this.port_id = id;
endfunction
    
//run task to get the packet from generator mailbox
task driver::run();
  $display("[%0s %2d] run started at time = %0t", this.name, this.port_id, $realtime);
  forever
    begin
      mbx_gen_drv.get(pkt);
      if(pkt.kind == STIMULUS)
        begin
          //pkt.display("DRV CHECK");
          no_of_pkts_received++;
        end
      //$display("[%0s %2d] received %0s packet %0d from generator at time=%0t", this.name, this.port_id, pkt.kind.name(), no_of_pkts_received, $realtime);
      drive(pkt);
      //$display("[%0s %2d] sent %0s packet from generator at time=%0t", this.name, this.port_id, pkt.kind.name(), no_of_pkts_received, $realtime);
    end
  $display("[%0s %2d] run ended at time = %0t", this.name, this.port_id, $realtime);
endtask
    
//drive task to identify the packet transaction type    
task driver::drive(packet pkt);
  case(pkt.kind)
    PRESET   : drive_preset(pkt);
    RESET    : drive_reset(pkt);
    STIMULUS : drive_stimulus(pkt);
    default  : $display("[%0s %2d] unknown packet received", this.name, this.port_id);
  endcase
endtask
    
//preset task to initialize the input port signal
task driver::drive_preset(packet pkt);
  //$display("[%0s %2d] driving %0s transaction into DUT started at time=%0t", this.name, this.port_id, pkt.kind.name(), $realtime);
  vif.cb.din <= '0;
  vif.cb.frame_n <= '1;
  vif.cb.valid_n <= '1;
  vif.reset_n <= 1'b1;
  @(vif.cb);
  //$display("[%0s %2d] driving %0s transaction into DUT ended at time=%0t", this.name, this.port_id, pkt.kind.name(), $realtime);
endtask
    
//reset task to apply reset to the design, after de-asserting reset signal, wait for 15 clock cyles beforing sending a packet to the router
task driver::drive_reset(packet pkt);
  //$display("[%0s %2d] driving %0s transaction into DUT started at time=%0t", this.name, this.port_id, pkt.kind.name(), $realtime);
  vif.reset_n <= 1'b0;
  @(vif.cb);
  vif.reset_n <= 1'b1;
  //wait time
  repeat(15) @(vif.cb);
  //$display("[%0s %2d] driving %0s transaction into DUT ended at time=%0t", this.name, this.port_id, pkt.kind.name(), $realtime);
endtask
    
//drive_stimulus task to drive the stimulus 
task driver::drive_stimulus(packet pkt);
  $display("[%0s %2d] driving %0s packet%0d sa%0d->da%0d into DUT started at time=%0t", this.name, this.port_id, pkt.kind.name(), no_of_pkts_received, port_id, pkt.da, $realtime);
  //$display("port_id : %0d da : %0d", port_id, pkt.da);
  //pkt.display("DRV1 CHECK");
  this.sem[pkt.da].get(1);
  send_addr(pkt);
  send_pad(pkt);
  send_payload(pkt);
  this.pkt_count++;
  this.sem[pkt.da].put(1);
  //drain time
  repeat(5) @(vif.cb);
  $display("[%0s %2d] driving %0s packet%0d sa%0d->da%0d into DUT ended at time=%0t", this.name, this.port_id, pkt.kind.name(), no_of_pkts_received, port_id, pkt.da, $realtime);
endtask
    
//send_addr task to send the destination address in the first four bits of the packet
task driver::send_addr(packet pkt);
  vif.cb.frame_n[port_id] <= 1'b0;
  for(int i = 0; i<4; i++)
    begin
      vif.cb.din[port_id] <= pkt.da[i];
      @(vif.cb);
    end
endtask
    
    
//send_pad task to send the padding bits in the next five bits of the packet    
task driver::send_pad(packet pkt);
  for(int i = 0; i<5; i++)
    begin
      vif.cb.din[port_id] <= 1'b1;
      vif.cb.frame_n[port_id] <= 1'b0;
      vif.cb.valid_n[port_id] <= 1'b1;
      @(vif.cb);
    end
endtask
    
//send_payload task to send the payload in bits
task driver::send_payload(packet pkt);
  foreach(pkt.payload[i])
    begin
      for(int k = 0; k<8; k++)
        begin
          vif.cb.din[port_id] <= pkt.payload[i][k];
          vif.cb.valid_n[port_id] <= 1'b0;
          vif.cb.frame_n[port_id] <= (i == (pkt.payload.size() - 1) && k == 7);
          @(vif.cb);
        end
    end
  vif.cb.valid_n[port_id] <= 1'b1;
endtask
  
    
//report task to keep a count of driven packets from driver
function void driver::report();
  $display("[%0s %2d] report: total packets driven are %0d at time=%0t", this.name, this.port_id, this.pkt_count,$realtime);
endfunction
    
