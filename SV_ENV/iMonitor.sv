//Input Monitor
class iMonitor;
  static bit [3:0] id; //used for incrementing port_id and persistent throughout the simulation
  bit [3:0] port_id; // sa port_id
  virtual router_if.iMon vif; //virtual interface handle
  mbx mbx_iMon_scb; //mailbox handle
  packet pkt; //packet handle
  string name; //Unique indentification for iMonitor component
  
  bit [31:0] no_of_pkts_received; //Number of packets sampled in iMonitor component
  
  //extern methods
  extern function new(string name = "iMonitor", input virtual router_if.iMon vif_arg, input mbx mbx_iMon_scb_arg);
  extern virtual task run();
  extern virtual function void report();
  
  
endclass
    
//constructor : to establish connections    
function iMonitor::new(string name = "iMonitor", input virtual router_if.iMon vif_arg, input mbx mbx_iMon_scb_arg);
  this.name = name;
  this.id++;
  this.port_id = this.id;
  this.vif = vif_arg;
  this.mbx_iMon_scb = mbx_iMon_scb_arg;
endfunction
    
//run task to collect the driven packet and place in mailbox for scoreboard reference    
task iMonitor::run();
  bit [7:0] inp_q[$];
  bit [7:0] data;
  bit [3:0] sa;
  bit [3:0] da;
  forever
    begin
      //collecting da port address
      @(negedge vif.cb_iMon.frame_n[port_id]);
      for(bit [2:0] i=0; i<4; i=i)
        begin
          da[i++] = vif.cb_iMon.din[port_id];
          @(vif.cb_iMon);
        end
      //collecting sa port address
      sa = port_id;
      //$display("SA:%2d DA:%2d time=%0t", sa,da,$realtime); 
      @(negedge vif.cb_iMon.valid_n[port_id]);
      //$display("[%0s %2d] started collecting packet at time = %0t", this.name, port_id, $realtime);     
      while(1)
        begin
          if(vif.cb_iMon.valid_n[port_id] == 1)
            begin
              pkt = new;
              pkt.inp_stream = inp_q;
              pkt.payload = inp_q;
              pkt.da = da;
              pkt.sa = sa;
              //$display("iMon : check");
              //pkt.display("iMon Check");
              //$display(inp_q);
              mbx_iMon_scb.put(pkt);
              no_of_pkts_received++;
              
              begin
                packet temp;
                #0 while(mbx_iMon_scb.num >= 1) void'(mbx_iMon_scb.try_get(temp));
              end
              
              //$display("[%0s %2d] sent packet%0d at time = %0t", this.name, port_id, no_of_pkts_received, $realtime);
              inp_q.delete();
              break;
            end
          //collecting payload
          for(bit [3:0] i = 0; i<8; i=i)
            begin
              data[i++] = vif.cb_iMon.din[port_id];
              @(vif.cb_iMon);
              if(i == 8)
                begin
                  inp_q.push_back(data);
                end
                
            end
        end
    end
  $display("[%0s %2d] run ended at time = %0t", this.name, port_id, $realtime);
endtask
    
    
//report function to keep a count of numbers of packets sampled in iMonitor component
function void iMonitor::report();
  $display("[%0s %2d] report: total packets monitored are %0d at time=%0t", this.name, this.port_id, this.no_of_pkts_received, $realtime);
endfunction
