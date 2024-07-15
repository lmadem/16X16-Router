//environment component
class environment extends uvm_env;
  //registering into factory
  `uvm_component_utils(environment)
  
  //input agent handle
  input_agent i_agent;
  //reset agent handle
  reset_agent r_agent;
  
  //constructor
  function new(string name = "environment", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    i_agent = input_agent::type_id::create("i_agent", this);
    uvm_config_db #(uvm_object_wrapper)::set(this, "i_agent.seqr.main_phase", "default_sequence", packet_sequence::get_type());
    
    r_agent = reset_agent::type_id::create("r_agent", this);
    uvm_config_db #(uvm_object_wrapper)::set(this, "r_agent.rst_seqr.reset_phase", "default_sequence", reset_sequence::get_type());
  endfunction
endclass
