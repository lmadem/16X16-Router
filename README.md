# 16X16 Router
Verification of 4X4 router in System Verilog & UVM. The main intension of this repository is to document the verification plan and test case implementation in System Verilog & UVM testbench environment.

<details>
  <summary> Defining the black box design of Router 16X16 </summary>

  #### The router has 16 input and 16 output ports. Each input and output port consists of 3 signals, serial data, frame and valid. These signals are represented in a bit-vector format, din[15:0], frame_n[15:0], valid_n[15:0], dout[15:0], frameo_n[15:0], and valido_n[15:0]
  
  <li> Input Signals : clk, reset_n, frame_n[15:0], valid_n[15:0], din[15:0] </li>

  <li> Output Ports : frameo_n[15:0], valido_n[15:0], dout[15:0] </li>

  <li> To drive an individual port, the specific bit position corresponding to the port number must be specified. For example, if input port 3 is to be driven, then the corresponding signals shall be din[3], frame_n[3], and valid_n[3] </li>

  <li> To sample an individual port, the specific bit position corresponding to the port number must be specified. For example, if output port 7 is to be sampled, then the corresponding signals shall be dout[7], frameo_n[7], and valido_n[7] </li>
  
  #### Black Box Design

  ![WhatsApp Image 2024-07-18 at 20 10 40](https://github.com/user-attachments/assets/8c198929-cef6-42b0-8fd1-577ab1587878)

  #### Input Packet Format

  ![WhatsApp Image 2024-07-18 at 20 23 50](https://github.com/user-attachments/assets/dc2a4af6-20b2-40ed-abfe-de854f033de5)

  <li> RTL(router) accepts 1-bit per clock </li>
  <li> frame_n : falling edge indicates first bit of packet, rising edge indicates last bit of packet </li>
  <li> valid_n : valid_n is low if payload bit is valid, otherwise high </li>  
  <li> din : Header (destination address & padding bits) and payload </li>

  <li> The first four bits in the packet are address bits, and the next five bits are padding bits, followed by the payload bits </li>

  #### Output Packet Format

  ![WhatsApp Image 2024-07-18 at 20 28 25](https://github.com/user-attachments/assets/2ec6c01f-f597-4d72-866e-87d737018fac)

  <li> Output activity is indicated by frameo_n, valido_n and dout </li>
  <li> dout is valid only when frameo_n output is low(expect for last bit) & valid_n output is low </li>

  #### Reset Signal

  ![WhatsApp Image 2024-07-18 at 20 34 17](https://github.com/user-attachments/assets/d88cdc59-0ee5-4aa8-8f2b-184c67d8c957)

  <li> While asserting reset_n, frame_n and valid_n must be de-asserted </li>
  <li> reset_n is asserted for atleast one clock cycle </li>
  <li> After de-asserting reset_n, wait for 15 clocks before sending a packet through the router </li>
  <li> During these 15 clock cycles, the router is performing self-initialization. Attempting to drive a packet through the router during this time, the self-initialization will fail and the router will not work correctly afterwards </li>

  <li> Please look into the "design.sv" file for further information </li>
  
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
