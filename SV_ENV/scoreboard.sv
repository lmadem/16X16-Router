//scoreboard class
class scoreboard;
  string name; //identifier

  mbx mbx_driver[15:0]; //driver mailbox
  mbx mbx_receiver[15:0]; //receiver mailbox
  
  packet pkt_inbox[15:0]; //packet object handle
  packet pkt_outbox[15:0]; //packet object handle
  
  packet qu_inp[$]; //queue for input packet
  
  bit [31:0] total_input_packets[15:0]; //To keep a count of collected packets from input monitor
  bit [31:0] total_output_packets[15:0]; //To keep a count of collected packets from output monitor
  
  bit [31:0] m_matches; //To keep a track of scoreboard matches
  bit [31:0] m_mismatches; //To keep a track of scoreboard mismatches
  
  //extern methods
  extern function new(string name = "scoreboard", input mbx mbx_driver_arg[15:0], mbx mbx_receiver_arg[15:0]);
  extern virtual task run();
  extern virtual task get_inp_pkt(bit [3:0] sa); 
  extern virtual task get_out_pkt(bit [3:0] da); 
  extern virtual function void search_and_compare_pkt(packet pkt);
  extern virtual function void report();
endclass
    
    
//constructor
function scoreboard::new(string name = "scoreboard", input mbx mbx_driver_arg[15:0], mbx mbx_receiver_arg[15:0]);
  this.name = name;
  for(bit [4:0] i=0; i<=15; i++)
    begin
      this.mbx_driver[i] = mbx_driver_arg[i];
      this.mbx_receiver[i] = mbx_receiver_arg[i];
    end
endfunction
    
//run task
task scoreboard::run();
  $display("[%0s] run started at time=%0t", this.name, $realtime);
  fork
    get_inp_pkt(0);
    get_inp_pkt(1);
    get_inp_pkt(2);
    get_inp_pkt(3);
    get_inp_pkt(4);
    get_inp_pkt(5);
    get_inp_pkt(6);
    get_inp_pkt(7);
    get_inp_pkt(8);
    get_inp_pkt(9);
    get_inp_pkt(10);
    get_inp_pkt(11);
    get_inp_pkt(12);
    get_inp_pkt(13);
    get_inp_pkt(14);
    get_inp_pkt(15);
    
    get_out_pkt(0);
    get_out_pkt(1);
    get_out_pkt(2);
    get_out_pkt(3);
    get_out_pkt(4);
    get_out_pkt(5);
    get_out_pkt(6);
    get_out_pkt(7);
    get_out_pkt(8);
    get_out_pkt(9);
    get_out_pkt(10);
    get_out_pkt(11);
    get_out_pkt(12);
    get_out_pkt(13);
    get_out_pkt(14);
    get_out_pkt(15);
    
  join
  
endtask
    
//get_inp_pkt method to collect input monitor packets and push in to a queue:qu_inp
task scoreboard::get_inp_pkt(bit [3:0] sa);
  packet inp_pkt;
  while(1)
    begin
      @(mbx_driver[sa].num);
      mbx_driver[sa].get(pkt_inbox[sa]);
      inp_pkt = new;
      inp_pkt.copy(pkt_inbox[sa]);
      qu_inp.push_back(inp_pkt);
      //inp_pkt.display("Scoreboard Inbox Check:");
      total_input_packets[sa]++;
      //$display("[%0s] input packet%0d received on %0s:%0d and total packets collected are %0d at time = %0t", this.name, total_input_packets[sa], this.name, sa, total_input_packets.sum(), $realtime);
    end
endtask

//get_out_pkt method to collect output monitor packets and push in to a queue:qu_out
task scoreboard::get_out_pkt(bit [3:0] da);
  packet out_pkt;
  while(1)
    begin
      @(mbx_receiver[da].num);
      mbx_receiver[da].get(pkt_outbox[da]);
      out_pkt = new;
      out_pkt.copy(pkt_outbox[da]);
      //out_pkt.display("Scoreboard Outbox Check:");
      total_output_packets[da]++;
      //$display("[%0s] output packet%0d received on %0s:%0d and total packets collected are %0d at time = %0t", this.name, total_output_packets[da], this.name, da, total_output_packets.sum(), $realtime);
      search_and_compare_pkt(pkt_outbox[da]);
    end
endtask    

    
//Search and compare function for the inputs and output packets comparison
function void scoreboard::search_and_compare_pkt(packet pkt);
  packet ref_pkt;
  int get_index[$];
  int index;
  bit done;
  string message;
  get_index = qu_inp.find_first_index() with (item.da == pkt.da);
  foreach(get_index[i])
    begin
      index = get_index[i];
      ref_pkt = qu_inp[index];
      if(ref_pkt.compare(pkt, message))
        begin
          m_matches++;
          qu_inp.delete(index);
          //$display("[SCB_MATCH] Packet matched at time=%0t",$time);
          //$display("matched = %0d", m_matches);
          done = 1;
          break;
        end
      else
        done = 0;
      
      if(!done)
        begin
          m_mismatches++;
          $display("[Error: SCB_NO_MATCH] Error ***** No Matching packet found ******* at time=%0t",$time);
          done = 0;
        end
    end
  
endfunction

//report function to keep a track of total sampled packets, matches, and mismatches in scoreboard components
function void scoreboard::report();
  $display("[Scoreboard] Report: total_packets_collected = %0d",total_output_packets.sum()); 
  $display("[Scoreboard] Report: Matches=%0d Mis_Matches=%0d",m_matches, m_mismatches); 
endfunction

