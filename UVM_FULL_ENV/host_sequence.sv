//host_sequence extends from uvm_sequence
class host_bfm_sequence extends uvm_sequence #(host_data);
  //registering into factory
  `uvm_object_utils(host_bfm_sequence)
  
  //constructor
  function new(string name = "host_bfm_sequence");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    set_automatic_phase_objection(1);
  endfunction
  
  //body method
  virtual task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    `uvm_do_with(req, {addr == 'h100; kind == host_data::READ;});
    `uvm_info("HOST BFM READ", {"\n", req.sprint()}, UVM_MEDIUM);
    
    `uvm_do_with(req, {addr == 'h100; data == '1; kind == host_data::WRITE;});
    `uvm_info("HOST BFM WRITE", {"\n", req.sprint()}, UVM_MEDIUM);
    
    `uvm_do_with(req, {addr == 'h100; kind == host_data::READ;});
    `uvm_info("HOST BFM READ", {"\n", req.sprint()}, UVM_MEDIUM);
    
  endtask
endclass
