//Generator class
class generator;
  string name; //identifier
  bit [31:0] pkt_count; //packet count, will be passed from test
  bit [31:0] pkt_id[15:0]; //packet id's
  packet pkt; //packet handle
  
  mbx mbx_gen_drv[15:0]; //mailbox handle, b/w generator and driver
  packet ref_pkt[15:0]; //reference packet handle
  
  //extern methods
  extern function new(string name = "generator", input mbx mbx_gen_drv_arg[15:0], input  bit [31:0] pkt_count_arg);
  extern virtual task run();
  extern virtual task generate_stimulus(bit [3:0] sa);  
  extern virtual function void report();
   
endclass
    
//constructor
function generator::new(string name = "generator", input mbx mbx_gen_drv_arg[15:0], input  bit [31:0] pkt_count_arg);
  this.name = name;
  this.pkt_count = pkt_count_arg;
  for(bit [4:0] i=0; i<=15; i++)
    begin
      this.mbx_gen_drv[i] = mbx_gen_drv_arg[i];
      this.ref_pkt[i] = new;
    end
endfunction
    
    
//run task
task generator::run();
  //generate first packet as PRESET packet
  pkt = new;
  
  //PRESET packet, this will be used in driver to identify
  pkt.kind = PRESET;
  //place the PRESET packet in mailbox
  for(bit [4:0] i=0; i<=15; i++)
    begin
      mbx_gen_drv[i].put(pkt);
    end
  //$display("[%0s] sent %0s packet to driver at time=%0t", this.name, pkt.kind.name(), $realtime);
  
  
  //generate second packet as RESET packet
  pkt = new;
  
  //RESET packet, this will be used in driver to identify
  pkt.kind = RESET;
  pkt.reset_cycles = 15;
  //place the RESET packet in mailbox
  for(bit [4:0] i=0; i<=15; i++)
    begin
      mbx_gen_drv[i].put(pkt);
    end
  //$display("[%0s] sent %0s packet to driver at time=%0t", this.name, pkt.kind.name(), $realtime);
    
  //generate stimulus packets for all ports
  fork
    generate_stimulus(0);
    generate_stimulus(1);
    generate_stimulus(2);
    generate_stimulus(3);
    generate_stimulus(4);
    generate_stimulus(5);
    generate_stimulus(6);
    generate_stimulus(7);
    generate_stimulus(8);
    generate_stimulus(9);
    generate_stimulus(10);
    generate_stimulus(11);
    generate_stimulus(12);
    generate_stimulus(13);
    generate_stimulus(14);
    generate_stimulus(15);
  join
  
endtask
    
//generate stimulus task
task generator::generate_stimulus(bit [3:0] sa);
  packet pkt;
  repeat(pkt_count)
    begin
      pkt_id[sa]++;
      assert(ref_pkt[sa].randomize());
      pkt = new;
      //STIMULUS packet, this will be used in driver to identify
      pkt.kind = STIMULUS;
      pkt.copy(ref_pkt[sa]);
      //place STIMULUS packet in mailbox
      mbx_gen_drv[sa].put(pkt);
      //$display("[%0s] GEN%0d packet %0d sent at time=%0t", this.name, sa, pkt_id[sa], $realtime);
      //pkt.display("GEN CHECK");
    end
endtask

//report function    
function void generator::report();
  $display("[%0s] report: total packets generated = %0d", this.name, pkt_id.sum());
endfunction
