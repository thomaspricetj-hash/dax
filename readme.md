DAX — Dual Address eXtension

Delta‑Merged Memory Architecture (DMM)

A proprietary memory‑centric compute paradigm designed by Thomas



Overview

DAX (Dual Address eXtension) is a formal ISA extension and architectural model built on Delta‑Merged Memory (DMM) — a dual‑address, XOR‑merged memory system that reduces bandwidth, improves cache locality, and enables instant snapshots, rollback, and multi‑agent overlays.



This repository serves as the official documentation and test‑only distribution for DAX and DMM.



It contains:



Specifications



Diagrams



Explanations



Design notes



Test‑ready RTL



FPGA integration files



Simulation harness



It does not contain production software, compilers, or full hardware implementations.



What DAX Is

DAX introduces a new memory paradigm:



Master Address (AM) — canonical data



Delta Address (AD) — sparse differences



Effective Value:



Code

V = M ⊕ D

Writes update only the delta region:



Code

D' = M ⊕ V\_new

This creates a compressed, reversible, high‑bandwidth memory model ideal for:



AI reasoning engines



multi‑agent systems



simulation frameworks



speculative execution



versioned memory systems



high‑bandwidth compute architectures



Repository Contents

Included

Full DAX ISA specification



Full DMM architectural whitepaper



Diagrams and conceptual models



Design notes and rationale



Integration concepts for future hardware



RTL for testing



FPGA top‑level for testing



AXI‑Lite control block



Simulation testbench



U55C constraint files



Not Included

Production code



Compilers



Simulators



Emulators



Commercial hardware models



Testing Instructions (FPGA + Simulation)

This repository includes test‑only RTL for validating the DAX memory model.



1\. Simulation

Use sim/tb\_dax\_meu.sv:



Run in Vivado or any SV simulator



Confirms LDX/STX behavior



Confirms delta‑merged memory correctness



2\. FPGA (Xilinx Alveo U55C)

The fpga/ folder contains:



top.sv



AXI‑Lite control block



U55C XDC constraints



To run on hardware:



Create a Vivado project



Select Alveo U55C



Add RTL from rtl/



Add constraints from fpga/constraints/



Build AXI‑Lite + PCIe block design



Generate bitstream



Load onto U55C



Use the Windows host test program to trigger:



LDX



STX



address updates



delta writes



merged value reads



This validates the full DAX pipeline.



Evaluation‑Only Notice

This repository is provided strictly for evaluation, testing, and academic review.



It is not licensed for:



commercial use



integration into products



redistribution



modification



derivative works



hardware manufacturing



software compilation



research outside your organization



Commercial Licensing Required

DAX, DMM, and all associated designs are proprietary intellectual property owned by Thomas.



Any use beyond evaluation — including but not limited to:



commercial deployment



hardware implementation



software integration



research publication



derivative architecture design



simulator development



compiler support



requires a paid commercial license and written permission from the author.



Contact information for licensing can be provided upon request.



License

Code

Copyright (c) 2026 Thomas. All rights reserved.



This project, including all designs, algorithms, architectures, and any

derivative or related upgrades, is proprietary and protected under

copyright law. No part of this work may be copied, modified, merged,

distributed, or used in any form without explicit written permission

from the author.



Unauthorized use of this project or any of its contained ideas,

including but not limited to architectural concepts, instruction set

extensions, memory models, compression schemes, or system designs, is

strictly prohibited.



This protection applies to all future revisions, enhancements, and

extensions of this work, whether published or unpublished.

