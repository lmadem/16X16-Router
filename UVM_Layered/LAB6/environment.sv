//environment component
class environment extends uvm_env;
  //input agent handle
  input_agent i_agent[16];
  //reset agent handle
  reset_agent r_agent;
  //output agent handle
  output_agent o_agent[16];
  //scoreboard handle
  scoreboard scb;
  //semaphore
  semaphore sem[];
  //coverage handle
  coverage cov;
  //registering into factory
  `uvm_component_utils(environment)
  
  //constructor
  function new(string name = "environment", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    //semaphore construction
    sem = new[16];
    foreach(sem[i])
      sem[i] = new(1);
    //constructing and configuring input agents with a dedicated port_id for each
    foreach(i_agent[i])
      begin
        i_agent[i] = input_agent::type_id::create($sformatf("i_agent[%0d]",i), this);
        uvm_config_db#(int)::set(this, i_agent[i].get_name(), "port_id", i);
        //uvm_config_db #(uvm_object_wrapper)::set(this, {i_agent[i].get_name(), ".", "seqr.main_phase"}, "default_sequence", packet_sequence::get_type());
        //configuring the sequencer's default_sequence to use packet sequencer library(packet_seq_lib) instead of packet_sequence
        uvm_config_db #(uvm_object_wrapper)::set(this, {i_agent[i].get_name(), ".", "seqr.main_phase"}, "default_sequence", packet_seq_lib::get_type());
      end
    
    //constructing and configuring output agents with a dedicated port_id for each
    foreach(o_agent[i])
      begin
        o_agent[i] = output_agent::type_id::create($sformatf("o_agent[%0d]",i), this);
        uvm_config_db#(int)::set(this, o_agent[i].get_name(), "port_id", i);
      end
    
    //constructing and configuring reset agent
    r_agent = reset_agent::type_id::create("r_agent", this);
    uvm_config_db #(uvm_object_wrapper)::set(this, "r_agent.rst_seqr.reset_phase", "default_sequence", reset_sequence::get_type());
    
    //constructing scoreboard component
    scb = scoreboard::type_id::create("scb", this);
    
    //constructing coverage component
    cov = coverage::type_id::create("cov", this);
  endfunction
  
  //connect phase to connect input & output monitors to scoreboard and pass semaphore to drive
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    foreach(i_agent[i])
      begin
        i_agent[i].analysis_port.connect(scb.before_export);
        i_agent[i].drv.sem = this.sem;
        i_agent[i].analysis_port.connect(cov.analysis_export);
      end
    
    foreach(o_agent[i])
      begin
        o_agent[i].analysis_port.connect(scb.after_export);
      end
    
    
                      
  endfunction
endclass
