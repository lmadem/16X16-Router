//host_driver extends from uvm_driver and typed to host_data
class host_driver extends uvm_driver #(host_data);
  //virtual interface handle
  virtual host_if host_if_inst;
  event go;
  //registering into factory
  `uvm_component_utils(host_driver)
  //constructor
  function new(string name = "host_driver", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if(!uvm_config_db#(virtual host_if)::get(this, "", "host_if", host_if_inst))
      begin
        `uvm_fatal("HST_CFGERR", "DUT host interface is not set");
      end
    
  endfunction
  
  
  //pre_reset_phase
  virtual task pre_reset_phase(uvm_phase phase);
    host_if_inst.cb_host_drv.wr_n <= 'x;
    host_if_inst.cb_host_drv.address <= 'x;
    host_if_inst.cb_host_drv.data <= 'x;
  endtask
  
  virtual task reset_phase(uvm_phase phase);
    host_if_inst.cb_host_drv.wr_n <= '1;
    host_if_inst.cb_host_drv.address <= '1;
    host_if_inst.cb_host_drv.data <= '1;
  endtask
  
  virtual task run_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    forever
      begin
        seq_item_port.get_next_item(req);
        `uvm_info("RUN", {"Before process\n", req.sprint()}, UVM_MEDIUM);
        data_rw();
        `uvm_info("RUN", {"After process\n", req.sprint()}, UVM_MEDIUM);
        seq_item_port.item_done();
      end
  endtask
  
  task suspend();
    wait(go.triggered);
  endtask
  
  virtual task data_rw();
      begin
        host_if_inst.cb_host_drv.wr_n <= 1'b0;
        host_if_inst.cb_host_drv.address <= req.addr;
        host_if_inst.cb_host_drv.data <= req.data;
        @(host_if_inst.cb_host_drv);
        ->go;
      end
  endtask
  
endclass
