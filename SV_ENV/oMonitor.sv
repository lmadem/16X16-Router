//Output Monitor
class oMonitor;
  static bit [3:0] id; //used for incrementing port_id's and persistent throughout the simulation
  bit [3:0] port_id; //da port_id
  virtual router_if.oMon vif; //virtual interface handle
  mbx mbx_oMon_scb; //mailbox handle
  packet pkt; //packet handle
  string name; //Unique indentification for oMonitor component
  
  bit [31:0] no_of_pkts_collected; //Number of packets collected in oMonitor component
  
  //extern methods
  extern function new(string name = "oMonitor", input virtual router_if.oMon vif_arg, input mbx mbx_oMon_scb_arg);
  extern virtual task run();
  extern virtual function void report();
endclass
    
//constructor : to establish connections  
function oMonitor::new(string name = "oMonitor", input virtual router_if.oMon vif_arg, input mbx mbx_oMon_scb_arg);
  this.id++;
  this.port_id = this.id;
  this.name = name;
  this.vif = vif_arg;
  this.mbx_oMon_scb = mbx_oMon_scb_arg;
  this.pkt = new;
endfunction
    
//run task to collect the packet from DUT and place in mailbox for scoreboard validation        
task oMonitor::run();
  bit [7:0] outp_q[$];
  bit [7:0] data;
  bit [3:0] da;
  $display("[%s %2d] run started at time=%0t", this.name, this.port_id, $realtime);
  
  /*
  //kill the simulation whenever output monitor goes in a forever loop - watchdog timer
  fork
    begin : watchdog_timer_fork
      fork : frameo_watchdog_timer_fork
        @(negedge vif.cb_oMon.frameo_n[port_id]);
        begin
          repeat(1000) @(vif.cb_oMon);
          $display("\n%m\n [Error] %t frame signal timed out\n", $realtime);
          $finish;
        end       
      join_any : frameo_watchdog_timer_fork
      disable fork;
    end : watchdog_timer_fork
  join
  */
  
  //collecting the packet  
  forever
    begin
      @(negedge vif.cb_oMon.valido_n[port_id]);
      da = port_id;
      //$display("DA : %4d", da);
      $display("[%0s %2d] started collecting packet at time = %0t", this.name, port_id, $realtime);
      while(1)
        begin
          if(vif.cb_oMon.valido_n[port_id] == 1)
            begin
              pkt = new;
              pkt.da = da;
              pkt.outp_stream = outp_q;
              //$display("oMon : check");
              //pkt.display("oMon Check");
              //$display(outp_q);
              mbx_oMon_scb.put(pkt);
              no_of_pkts_collected++;
              
              
              begin
                packet temp;
                #0 while(mbx_oMon_scb.num >= 1) void'(mbx_oMon_scb.try_get(temp));
              end
              
              
              //$display("[%0s %2d] sent packet%0d at time = %0t", this.name, port_id, no_of_pkts_collected, $realtime);
              outp_q.delete();
              break;
            end
          for(bit [3:0] i = 0; i<8; i=i)
            begin
              data[i++] = vif.cb_oMon.dout[port_id];
              @(vif.cb_oMon);
              if(i == 8)
                begin
                  outp_q.push_back(data);
                end
                
            end
        end
    end
  $display("[%s %2d] run ended at time=%0t", this.name, this.port_id, $realtime);
endtask
      
 
//report function to keep a count of numbers of packets collected in oMonitor component
function void oMonitor::report();
  $display("[%0s %2d] report: total packets collected are %0d at time=%0t", this.name, this.port_id, this.no_of_pkts_collected, $realtime);
endfunction
      
      
