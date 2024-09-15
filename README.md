# 16X16 Router
Verification of 16X16 router in System Verilog & UVM. The main intension of this repository is to document the verification plan and test case implementation in System Verilog & UVM testbench environment.

<details>
  <summary> Defining the black box design of Router 16X16 </summary>

  #### Router 16X16 is a switch, which can transfer a series of packets from source ports to the destination ports 
  
  <li> Note :: This DUT is not synthesizable, it is only designed for verification practices. The design has control & status registers </li>

  <li> Input Ports : clk, reset, sa1, sa2, sa3, sa4, sa1_valid, sa2_valid, sa3_valid, sa4_valid </li>

  <li> Output Ports : da1, da2, da3, da4, da1_valid, da2_valid, da3_valid, da4_valid </li>

  #### Black Box Design

  ![image](https://github.com/lmadem/4X4-Router/assets/93139766/b17d4f5a-5f71-459c-b057-f427bcd7fe37)


  #### Packet Format

  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/7fff2584-70f0-4da7-ac12-d0b45958d596)

  <li> Minimum packet length is 12 bytes and max is 2000 bytes </li>
  <li> RTL(router) accepts 8-bits per clock </li>
  <li> inp_valid indicates start/end of packet at the source port </li>
  <li> outp_valid indicates start/end of packet at the destination port </li>  
  
  #### I/O Pins

  ![image](https://github.com/lmadem/4X4-Router/assets/93139766/9e6a135e-fd50-4c93-9222-af9b49fcc1f8)


  #### pins to access Control Registers

  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/85085177-f3a3-4f23-b4f1-3c7958c807b9)

  #### Control Registers
  
  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/c2dda49e-ffbf-4f2b-9a99-243d69e2078d)


  #### Status Registers

  ![image](https://github.com/lmadem/4X4-Router/assets/93139766/0693cf5e-54d7-40f9-a6c7-955a65264756)

  <li> Apart from the above mentioned status registers, the DUT has other status registers. Please look into the "router.sv" file for further information </li>
  <li> This router 4X4 is designed in system verilog </li>
  
</details>

<details>
  <summary> Verification Plan </summary>

  #### The verification plan for Router 4X4 

  <li> The idea is to build a robust verification environment in system verilog & UVM which can handle various testcases. The testcases has basic functionality checks, functional coverage hits, covering corner cases, erroneous cases, and error-injection checks</li>

  #### Test Plan

  ![image](https://github.com/lmadem/4X4-Router/assets/93139766/9c468ab8-d5bf-42e0-affd-741b93cbb33a)


</details>

<details>
  <summary> Verification Results </summary>

   <li> Built a robust verification environment in System Verilog & UVM and implemented all the testcases as per the testplan. The SV testbench verification environment consists of header class, packet class, generator class, multiple drivers, multiple monitors, and scoreboard class, environment class, base_test class, test classes, program block, top module, interface and the design </li>
   <li> THE UVM verification environment consists of transaction class, sequences, sequencer, multiple master agents, multiple slave agents, scoreboard, coverage component, environment and test components</li>
   <li> This environment will be able to drive one testcase per simulation </li>

   #### Test Plan Status

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/f6f0d3ad-d63c-4dca-bdd0-048a99175c98)
   
</details>

   

  
</details>

<details>
  <summary> EDA Playground Links </summary>

  #### EDA Playground Link

  ```bash
https://www.edaplayground.com/x/Miur
  ```

  ```bash
https://www.edaplayground.com/x/LyEi
  ```


  #### Verification Standards

  <li>SV : Constrained random stimulus, robust generator, multiple drivers, multiple monitors, out-of-order scoreboard, coverage component and environment </li>

  <li>UVM : Factory override mechanisms, UVM callbacks, and In-line constraints </li>

  
</details>

<details>
  <summary>Challenge</summary>

#### The error-injection and erroneous cases 
<li> The simulation environment is hanging and going into a forever loop. It is because the run() task of driver, imonitor and omonitor components run forever, the output monitor block will end up in a forever loop when the stimulus is error-injected or erroneous </li>
<li> Here, the design has status registers and it became easy to test error-injection and erroneous testcases </li>
<li> But in general, the mechanism to control the simulation environment in an organized way even for error-injection and erroneous cases are bit tricky</li>
<li> The solution would be using UVM, as it has objections and timeouts </li>
<li> Reference link for the above problem : https://verificationacademy.com/forums/t/how-to-stop-a-simulation-in-a-controlled-way/35064 </li>


</details>


