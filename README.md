🚀 5-Stage Pipelined RISC-V Processor
🧩 Overview

This project implements a 32-bit RISC-V CPU in Verilog, featuring a 5-stage pipelined architecture — Fetch, Decode, Execute, Memory, Write-Back.
It supports RV32IMC instructions and can run C programs compiled using a standard RISC-V GCC toolchain.

The design focuses on correctness, clarity, and performance, with data forwarding and hazard detection to maintain pipeline efficiency.

⚙️ Key Features
🧠 ISA Support

RV32I – Base Integer instructions

M – Multiply and Divide

C – Compressed instructions (reduces code size by ~30%)

🏗️ 5-Stage Pipeline

IF – Instruction Fetch

ID – Decode & Register Fetch

EX – Execute / Address Calculation

MEM – Memory Access

WB – Write Back

🔄 Hazard Handling

Data Forwarding: Handles RAW hazards by forwarding data from EX/MEM stages.

Load-Use Detection: Stalls pipeline for one cycle when needed.

Branch Prediction: Branches resolved in Decode stage → only one-cycle penalty.

🧱 Architecture Components

Control Unit

Register File

ALU

Pipeline Registers

Forwarding & Hazard Detection Units

Instruction & Data Memory

🧰 Tools & Requirements

RISC-V GCC Toolchain (riscv64-unknown-elf-gcc, objdump)

Verilog Simulator: Icarus Verilog (iverilog, vvp)

Build System: make
