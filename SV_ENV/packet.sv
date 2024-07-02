//control knob to identify the transaction type
typedef enum {PRESET, RESET, STIMULUS} pkt_type_t;

//Transaction class - router packet
class packet;
  rand bit [3:0] sa; //source - input port address
  rand bit [3:0] da; //destination - output port address
  rand bit [7:0] payload[$]; //payload
  
  bit [7:0] inp_stream[$]; //collect driven packet
  bit [7:0] outp_stream[$]; //collect dut output
  
  //stimulus type
  pkt_type_t kind;
  
  //reset_cycles variable
  bit [4:0] reset_cycles;
  
  string name; //identifier 
  
  //constraints to generate stimulus within the range
  constraint valid_sa{
    sa inside {[0:15]};
  }
  
  constraint valid_da{
    da inside {[0:15]};
  }
  
  constraint valid_payload{
    payload.size() inside {[2:3]};
    //payload.size() == 3;
  }
  
  //extern methods
  extern function new(string name = "packet");
  extern function void copy(packet rhs);
  extern function bit compare(packet pkt2cmp, ref string message);
  extern function void display(string prefix = "DISPLAY");
  extern virtual function void randomize_with_combinations();
  extern function void post_randomize();
endclass
    
    
//constructor
function packet::new(string name = "packet");
  this.name = name;
endfunction

//copy function
function void packet::copy(packet rhs);
  if(rhs == null)
    begin
      $display("[%s] : [Error] null handle passed to copy method", this.name);
      $finish;
    end
  this.sa = rhs.sa;
  this.da = rhs.da;
  this.payload = rhs.payload;
  this.inp_stream = rhs.inp_stream;
  this.outp_stream = rhs.outp_stream;
endfunction
    
//compare function
function bit packet::compare(packet pkt2cmp, ref string message);
  if(this.inp_stream.size() != pkt2cmp.outp_stream.size())
      begin
        message = "payload size mismatch:\n";
        message = {message, $sformatf("inp_stream.size = %0d outp_stream.size = %0d\n", inp_stream.size(), pkt2cmp.outp_stream.size())};
        return(0);
      end
  if(this.inp_stream == pkt2cmp.outp_stream)
    begin
      message = "Successfully Compared";
      return(1);
    end
  else
    begin
      message ="Payload Content Mismatch:\n";
      message = {message,$sformatf("Packet Sent: %p\n Pkt Received: %p",this.inp_stream, pkt2cmp.outp_stream)};
      return(0);
    end
endfunction
    
    
//Display function
function void packet::display(string prefix = "DISPLAY");
  $display("[%s:%s] time = %0t sa = %0d, da = %0d", this.name, prefix, $realtime, sa, da);
  foreach(payload[index])
    $display("[%s:%s] time = %0t payload[%0d] = %0h", this.name, prefix, $realtime, index, payload[index]);
endfunction

//randomize_with_combinations : a function hook, will be implemented in derived class
function void packet::randomize_with_combinations();
  //Reserved for future
endfunction
    
//post-randomize function
function void packet::post_randomize();
  randomize_with_combinations();
endfunction

