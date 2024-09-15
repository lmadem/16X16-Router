//TestCase7 : The test is to configure the DUT registers without the RAL environment. To proceed with this case, need to disable all the output ports in the design and see how the design is processing when the configuration signals are de-asserted. Also, verify the design functionality after configuring DUT registers from testbench environment. Should see the packets coming through destination ports

//STEP 1
//before running this case, change line 88 in the design.sv file to lock <= '1(disabling all the destination ports) - check out the waveforms, the destination ports should be blank

//STEP2
//enable the lines(23-27) in router_env_pkg.sv 

//SETP3
//No we are configuring the dut register without the RAL environment
//step 1 : define a handle for host_agent, enable line 8 in the "environment.sv" file
//step 2 : constructing and configuring host agent, enable line 59&60 in "environment.sv" file

//STEP4
//run this test, should see the packets flowing through the destination ports, as we have configured the dut register(lock) from the environment

//STEP5
//disable the following lines to avoid issues in the environment
//step1 : change line 88 in the design.sv file to lock <= '0(enabling all the destination ports)
//step2 : disable the lines(23-27) in router_env_pkg.sv 
//step3 : disable line 8 in the "environment.sv" file
//step4 : disable line 59&60 in "environment.sv" file


//testcase7 component
class testcase7 extends base_test;
  //registering into factory
  `uvm_component_utils(testcase7)
 
  
  //constructor
  function new(string name = "testcase7", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_config_db#(int)::set(this, "env.i_agent*.seqr", "item_count", 10);
    uvm_config_db#(virtual host_if)::set(this, "env.h_agent", "host_if", top.host_if_inst);
  endfunction
  
  //start of simulation phase
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_top.print_topology();
    uvm_factory::get().print();
  endfunction

endclass
