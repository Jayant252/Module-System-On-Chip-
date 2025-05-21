# Module-System-On-Chip-
# Custom Register File SoC with Scan Chain and TAP Controller

A Lab-Oriented System-on-Chip (SoC) project designed and deployed on the Zynq-7000 FPGA board, integrating a custom 32x32-bit register file peripheral, interfaced via AXI4-Lite with an ARM Cortex-A9 processor. The design is also scan-testable using an IEEE 1149.1-compliant TAP controller.

## 🚀 Overview

This project aims to create a custom SoC architecture comprising:

- A memory-mapped **32x32-bit register file** (RISC-V compliant).
- Communication over **AXI4-Lite** between custom IP and ARM Cortex-A9.
- **Scan chain** and **TAP Controller** for boundary-scan testing (JTAG).
- Hardware testing and software applications developed using **Vivado** and **Vitis** tools.

## 🔧 Key Features

| Feature           | Description                                    |
|-------------------|------------------------------------------------|
| Processing Core   | ARM Cortex-A9 (Zynq-7000 SoC)                  |
| Register File     | 32 general-purpose registers (32-bit)          |
| Bus Interface     | AXI4-Lite Slave                                |
| Debug System      | TAP Controller, Scan Chain                     |
| Test Interface    | IEEE 1149.1 JTAG-compliant                     |
| Application IDE   | Xilinx Vivado & Vitis                          |

## 📐 Architecture

The SoC design consists of:
- **Processing System (PS)**: ARM Cortex-A9
- **Programmable Logic (PL)**: Custom IP core with register file & TAP
- **AXI4-Lite Bus**: Communication between PS and PL
- **Scan Chain**: 1024 scan flip-flops for full register file testability
- **TAP Controller**: Handles scan instructions and test patterns

## 🛠 Installation & Build

1. Open **Vivado** and import the project sources (VHDL files).
2. Synthesize and implement the design.
3. Export hardware wrapper (XSA file) for use in **Vitis**.
4. In **Vitis**, develop application firmware using provided drivers:
    - `initRegFile`
    - `writeRegFile`
    - `readRegFileR1`
    - `readRegFileR2`
    - `resetRegFile`
    - `writeDisable`
    - `scanEnable`

## 🧪 Testing

Three key test cases were simulated:

- **Register File Write & Read**  
  Verified correct data storage and retrieval.

- **Scan Chain Operation**  
  Verified 1024-bit scan chain shift operation with TAP controller.

- **Bypass Test**  
  Verified TDI to TDO passthrough in ShiftDR state.

## 💡 Applications

- Memory-mapped register interface for ARM processors
- Testable designs for embedded systems via JTAG
- Scan chain debugging in complex SoC environments

## 👨‍💻 Authors

- Jayant Patil  
- Aditya Grewal  
- Avanindra Kumar Mishra  
- Sagar Shreeshailappa Hosmani  

Hochschule Ravensburg-Weingarten – Master of Electrical Engineering & Embedded Systems  
Under the guidance of **Prof. Dr. A. Siggelkow**

## 📄 License

This project is intended for educational purposes. 
---

