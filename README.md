# 16X16 Router
Verification of 16X16 router in System Verilog & UVM. The main intension of this repository is to document the verification plan and test case implementation in System Verilog & UVM testbench environment.

<details>
  <summary> Defining the black box design of Router 16X16 </summary>

  #### Router 16X16 a crosspoint switch, which can transfer a series of packets from source ports to the destination ports 
  
  <li> The router has 16 input and 16 output ports. Each input and output port consists of 3 signals, serial data, frame and valid. These signals are represented in a bit-vector format, din[15:0], frame_n[15:0], valid_n[15:0], dout[15:0], frameo_n[15:0] and valido_n[ 15:0] </li>

  <li> Input Ports : din, frame_n, valid_n, reset_n, clock </li>

  <li> Output Ports : dout, frameo_n, valido_n </li>

  <li> To drive an individual port, the specific bit position corresponding to the port number must be specified. For example, if input port 3 is to be driven, then the corresponding signals shall be din[3], frame_n[3] and valid_n[3] </li>

  <li> To sample an individual port, the specific bit position corresponding to the port number must be specified. For example, if output port 7 is to be sampled, then the corresponding signals shall be dout[7], frameo_n[7] and valido_n[7]  </li>

  #### Black Box Design

  ![image](https://github.com/user-attachments/assets/4dd9dc04-49dd-4030-a631-05660817fe25)

  #### Packet Format

  <li> The packet driving mechanism should follow the certain requirements </li>

  <li> The first four bits should be the destination address, and the next five bits should be the padding bits(0/1), followed by payload bit data (payload is in bytes) </li>

  <li> While starting the packet, the frame_n should be de-asserted for the corresponding port and it should be asserted high before the last bit of payload data. This signal indicates the start and end of transaction </li>

  <li> The valid_n should be deasserted when driving the payload data and it should be asserted high after completed the payload data bits. This signals indicates the valid payload data </li>

  #### Input Packet Structure

  ![image](https://github.com/user-attachments/assets/81e0ce6c-4f72-420a-b810-d54628edbbee)

  #### Output Packet Structure

  ![image](https://github.com/user-attachments/assets/a99e0e99-14d6-4da5-991e-79b4a0037163)

  #### Functional Perspective
  
  ![image](https://github.com/user-attachments/assets/97790623-6db2-4345-801e-de20c9641b84)

  
</details>

<details>
  <summary> Verification Plan </summary>

  #### The verification plan for Router 16X16 

  <li> The idea is to build a robust & re-usable verification environment in system verilog & UVM which can handle various testcases. The testcases has basic functionality checks, functional coverage hits, and covering various test scenarios </li>

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




