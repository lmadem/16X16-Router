//packet_sa_da class extends from base class packet
class packet_sa_da extends packet;
  
  //registering into factory
  `uvm_object_utils(packet_sa_da)
  
  //constructor
  function new(string name = "packet_sa_da");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //Here we are fixing both the sa and da addresses
  virtual function void randomize_with_combinations();
    static bit [4:0] flag1 = 0;
    static bit [4:0] flag2 = 0;
    for(bit [4:0] j=0; j<=15; j++) begin
      if(flag1 == j) begin
        sa = j;
        da = flag2;
        //$display("ChecK: Packet");
        //$display("sa : %0d, da : %0d", sa, da);
      end
    end
    
    flag1++;
    if(flag1 == 16) begin
      flag1 = 0;
      flag2++;
      if(flag2 == 16)
        flag2 = 0;
    end

  endfunction
  


endclass