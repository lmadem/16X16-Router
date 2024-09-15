//environment component
class environment extends uvm_env;
  //input agent handle
  input_agent i_agent[16];
  //reset agent handle
  reset_agent r_agent;
  //host_agent handle
  //host_agent h_agent;
  //output agent handle
  output_agent o_agent[16];
  //scoreboard handle
  scoreboard #(packet) scb;
  //semaphore for input ports
  semaphore sem_sa[];
  //semaphore for output ports
  semaphore sem_da[];
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
    sem_sa = new[16];
    sem_da = new[16];
    foreach(sem_sa[i])
      sem_sa[i] = new(1);
    foreach(sem_da[i])
      sem_da[i] = new(1);
    //constructing and configuring input agents with a dedicated port_id for each
    foreach(i_agent[i])
      begin
        i_agent[i] = input_agent::type_id::create($sformatf("i_agent[%0d]",i), this);
        uvm_config_db#(int)::set(this, i_agent[i].get_name(), "port_id", i);
        uvm_config_db #(uvm_object_wrapper)::set(this, {i_agent[i].get_name(), ".", "seqr.main_phase"}, "default_sequence", packet_sequence::get_type());
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
    
    //constructing and configuring host agent
    //h_agent = host_agent::type_id::create("h_agent", this);
    //uvm_config_db#(uvm_object_wrapper)::set(this, "h_agent.h_seqr.configure_phase", "default_sequence", host_bfm_sequence::get_type());
    
    //constructing scoreboard component
    scb = scoreboard#(packet)::type_id::create("scb", this);
    
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
        i_agent[i].drv.sem_sa = this.sem_sa;
        i_agent[i].drv.sem_da = this.sem_da;
        i_agent[i].analysis_port.connect(cov.analysis_export);
      end
    
    foreach(o_agent[i])
      begin
        o_agent[i].analysis_port.connect(scb.after_export);
      end
    
    
                      
  endfunction
endclass