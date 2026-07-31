DAX — Dual Address eXtension

Delta‑Merged Memory Architecture (DMM)

A new memory‑centric compute paradigm designed by Thomas



Overview

DAX (Dual Address eXtension) is a formal ISA extension and architectural model built on Delta‑Merged Memory (DMM) — a dual‑address, XOR‑merged memory system that reduces bandwidth, improves cache locality, and enables instant snapshots, rollback, and multi‑agent overlays.



This repository serves as the official documentation hub for DAX and DMM.

It contains specifications, diagrams, explanations, and design notes only.

No simulators, test harnesses, or runnable code are included.



What DAX Is

DAX introduces a new memory paradigm:



Master Address (AM) — canonical data



Delta Address (AD) — sparse differences



Effective Value:



𝑉

=

𝑀

⊕

𝐷

Writes update only the delta region:



𝐷

′

=

𝑀

⊕

𝑉

new

This creates a compressed, reversible, high‑bandwidth memory model ideal for AI systems, simulations, multi‑agent reasoning, and speculative execution.



Why This Repository Exists

This GitHub repository is not a codebase.

It is a technical reference for:



ISA documentation



architectural design



memory model theory



diagrams and conceptual layouts



integration notes for future systems



research‑grade explanations



Everything here is meant to be read, studied, and referenced.



Key Concepts

Delta‑Merged Memory (DMM)

A dual‑address memory model where values are reconstructed from:



canonical master data



sparse delta overlays



DAX ISA Extension

Two new instructions:



LDX — Delta Load

Code

LDX rt, (rm, rd)

Loads M XOR D.



STX — Delta Store

Code

STX rs, (rm, rd)

Stores only the delta.



Transparent Delta Mode

Optional CSR flag enabling automatic delta merging for normal loads/stores.



Repository Contents

This repo includes:



Full DAX ISA specification



Full DMM architectural whitepaper



Diagrams and conceptual models



Design notes and rationale



Integration concepts for future hardware



Documentation for researchers and implementers



This repo does not include:



code



simulators



test harnesses



compilers



hardware models



emulators



Use Cases

DAX and DMM are designed for:



AI reasoning engines



multi‑agent systems



simulation frameworks



speculative execution



versioned memory systems



high‑bandwidth compute architectures



Status

DAX is an active research architecture.

This repository documents the design as it evolves.



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

