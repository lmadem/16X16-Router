//packet sequence
class packet_sequence extends uvm_sequence #(packet);
  
  //number of items to create
  int item_count = 1;
  
  //Input port (source address)
  int port_id = -1;
  
  //Destination address enable
  bit [15:0] da_enable = '1;
  
  //used to constrain da
  int valid_da[$];
  
  //registering into factory
  `uvm_object_utils_begin(packet_sequence)
  `uvm_field_int(item_count, UVM_ALL_ON)
  `uvm_field_int(port_id, UVM_ALL_ON)
  `uvm_field_int(da_enable, UVM_ALL_ON)
  `uvm_field_queue_int(valid_da, UVM_ALL_ON)
  `uvm_object_utils_end
  
  
  
  //constructor
  function new(string name = "packet_sequence");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    set_automatic_phase_objection(1);
  endfunction
  
  //pre-randomize function
  function void pre_randomize();
    uvm_config_db#(int)::get(m_sequencer,"","item_count", item_count);
    uvm_config_db#(int)::get(m_sequencer,"", "port_id", port_id);
    uvm_config_db#(bit [15:0])::get(m_sequencer,"", "da_enable", da_enable);
    if(!(port_id inside {-1, [0:15]}))
      begin
        `uvm_fatal("CFG_ERR", $sformatf("Illegal Source Port ID = %0d", port_id));
      end
    
    //clear the queue
    valid_da.delete();
    for(bit [4:0] i=0; i<16; i++)
      begin
        if(da_enable[i])
          begin
            valid_da.push_back(i);
          end
      end
  endfunction
  
  //body method
  task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    repeat(item_count)
      begin
        `uvm_create(req);
        assert(req.randomize() with {if (port_id == -1) sa inside {[0:15]};
                                     else sa == port_id;
                                     da inside {valid_da};
                                    });
        start_item(req);
        finish_item(req);
        //$display("Generator");
        //req.print();
      end
  endtask
endclass
