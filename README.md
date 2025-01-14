# SPI Slave Module

## Overview
This project implements an **SPI Slave** module in Verilog, designed to interface with an SPI Master. The module receives data serially through the `MOSI` line, processes it, and sends data back via the `MISO` line. The design adheres to the SPI communication protocol, supporting an 8-bit data width.

---

## Features
- **Full-Duplex Communication**: Simultaneously sends and receives data between Master and Slave.
- **8-bit Data Register**: Stores the received data for further processing.
- **Shift Register Logic**: Handles serial-to-parallel data conversion.
- **Active-Low Chip Select (CS)**: Enables communication when `CS` is asserted (`0`).

---

## Inputs and Outputs

### **Inputs**
| Signal Name | Width | Description                                              |
|-------------|-------|----------------------------------------------------------|
| `clk`       | 1     | System clock signal.                                     |
| `rst_n`     | 1     | Active-low reset signal. Resets the internal state.       |
| `mosi`      | 1     | Master Out Slave In: Receives serial data from Master.   |
| `sck`       | 1     | Serial clock signal from Master for data synchronization.|
| `cs`        | 1     | Active-low chip select to enable communication.          |

### **Outputs**
| Signal Name | Width | Description                                              |
|-------------|-------|----------------------------------------------------------|
| `miso`      | 1     | Master In Slave Out: Sends serial data to Master.        |
| `data_out`  | 8     | Stores the received 8-bit data from `mosi`.              |

---

## Internal Logic
1. **Shift Register**:  
   - Shifts incoming bits from `mosi` on every `sck` edge when `cs` is active (`0`).
   - Captures the full 8-bit data after receiving 8 bits.

2. **MISO Data Output**:  
   - Sends the most significant bit (MSB) of the shift register on the `miso` line.

3. **Reset Behavior**:  
   - Clears `miso`, `data_out`, `shift_reg`, and `bit_cnt` when `rst_n` is low.

4. **Communication Control**:  
   - Data reception and transmission occur only when `cs` is asserted (`0`).

---
