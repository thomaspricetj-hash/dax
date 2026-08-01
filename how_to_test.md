How to Install \& Test DAX (Evaluation‑Only)

This repository includes test‑only RTL and FPGA integration files for evaluating the DAX (Dual Address eXtension) architecture.

All testing is strictly limited to non‑commercial evaluation, as defined in the Thomas Exclusive Purchase‑Only License (TPL‑1.1).



No rights are granted for production use, integration, modification, or derivative work.

Any use beyond testing requires a paid commercial license from Thomas.



1\. Requirements

To run the DAX test environment, you need:



Xilinx Vivado (2023.x or later)



Xilinx Alveo U55C accelerator card



U55C Board Files (included in this repo)



U55C XDC Constraints (included in this repo)



Windows or Linux host machine



PCIe access / XRT runtime



DAX RTL files (included in rtl/)



DAX FPGA top‑level (included in fpga/)



Simulation testbench (included in sim/)



This setup is for testing only and does not grant rights to deploy, integrate, or commercialize DAX.



2\. Install the U55C Board Files (Vivado)

Place the board files into your Vivado installation:



Code

C:\\Xilinx\\Vivado\\<version>\\data\\boards\\board\_files\\au55c\\

Restart Vivado.

You should now see Alveo U55C in the board selection menu.



3\. Create the DAX Vivado Project

Inside Vivado:



Create New Project



Select Alveo U55C as the target board



Add RTL files from:



Code

dax/rtl/

Add the top‑level FPGA file:



Code

dax/fpga/top.sv

Add the U55C constraints:



Code

dax/fpga/constraints/U55C\_xdc\_1v00.xdc

Create a block design:



PCIe XDMA → AXI‑Lite → axi\_lite\_dax\_ctrl.sv



Connect DAX MEU + master/delta memories



Run:



Synthesis



Implementation



Bitstream Generation



This produces a test‑only bitstream for the U55C.



4\. Run Simulation (Optional but Recommended)

Use the included testbench:



Code

dax/sim/tb\_dax\_meu.sv

Run:



Behavioral simulation



LDX/STX correctness checks



Delta‑merge validation



This confirms the DAX memory model before hardware testing.



5\. Load the Bitstream onto the U55C

Use either:



Vivado Hardware Manager (JTAG)



XRT / xbutil / xbmgmt (PCIe)



Once loaded, the FPGA is ready for DAX testing.



6\. Run Host‑Side DAX Tests

Use your Windows or Linux host application to:



Write ADDR\_M



Write ADDR\_D



Write NEW\_VALUE



Pulse LDX\_EN



Pulse STX\_EN



Read V\_OUT



This validates:



Delta‑Merged Memory (DMM)



LDX (load merged value)



STX (delta‑only store)



Effective value reconstruction



Master/delta memory behavior



AXI‑Lite control path



PCIe communication



This is the complete DAX evaluation workflow.



Evaluation‑Only Notice

All installation and testing instructions provided here are for evaluation purposes only.



You are permitted to:



Read the documentation



Build the test FPGA project



Run the simulation



Load the test bitstream



Execute the test harness



You are NOT permitted to:



Use DAX in any commercial product



Integrate DAX into hardware or software



Modify or extend the architecture



Publish derivative work



Redistribute any part of the design



Use DAX concepts in your own architecture



Build competing technology based on DAX ideas



All such actions require a paid commercial license from Thomas.



Commercial Licensing

If you wish to:



Use DAX in a real system



Integrate DAX into hardware or software



Build on the DAX ISA



Use DMM in any product



Develop compilers, simulators, or hardware around DAX



Publish research using DAX



Create derivative architectures



You must obtain a commercial purchase agreement directly from Thomas.



No exceptions.

No implied rights.

No loopholes.

