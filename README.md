# AXI4-Lite Slave — RTL to GDSII

A parameterized **AXI4-Lite Slave Peripheral** designed in SystemVerilog, verified at RTL, and taken through a complete **RTL-to-GDSII ASIC flow** using Yosys, OpenLane2, and the Sky130 PDK.

## Project Overview

The design is split into three main blocks:

* **AXI4-Lite Write Channel**
* **AXI4-Lite Read Channel**
* **Register File**

These blocks are integrated into the complete AXI4-Lite.

The design supports configurable data/address widths and byte-level register writes using `WSTRB`.

## Verification

The RTL was verified using **SystemVerilog testbenches** and **UVM**.

Verification covered:

* AXI4-Lite read/write transactions
* Address decoding
* Register read/write operations
* `WSTRB` byte enables
* Read/write responses
* Reset behavior
* Protocol-level functionality

Simulation logs and verification results are included in the main project.

## RTL → GDSII Flow

After RTL verification, the design was taken through an ASIC implementation flow:

```text
SystemVerilog RTL
       ↓
RTL Simulation
       ↓
UVM Verification
       ↓
Yosys Synthesis
       ↓
OpenLane2
       ↓
Floorplanning
       ↓
Placement
       ↓
Clock Tree Synthesis
       ↓
Routing
       ↓
Static Timing Analysis
       ↓
DRC / LVS / Antenna Checks
       ↓
GDSII
```

## ASIC Flow

The physical implementation was performed using:

* **Yosys** — RTL synthesis
* **OpenLane2** — RTL-to-GDSII flow
* **Sky130 PDK** — target technology

### Final Results

| Metric                 |       Result |
| ---------------------- | -----------: |
| Die Area               | 50,151.8 µm² |
| Core Area              | 42,886.1 µm² |
| Utilization            |       68.36% |
| Standard Cells         |        2,736 |
| Macros                 |            0 |
| I/O                    |          138 |
| Routed Nets            |        2,213 |
| Wirelength             |    52,758 µm |
| Vias                   |       14,037 |
| Setup Violations       |            0 |
| Hold Violations        |            0 |
| Capacitance Violations |            0 |
| DRC Errors             |            0 |
| LVS Errors             |            0 |
| Antenna Violations     |            0 |

The current implementation has remaining **fanout and slew violations** that would need to be cleaned up before considering the design fully tapeout-ready.

## Final Output

The main output of this flow is:

```text
gds/axi4_lite.gds
```

This is the physical GDSII representation of the synthesized and routed AXI4-Lite design.

## Tools

* SystemVerilog
* UVM
* Yosys
* OpenLane2
* Sky130 PDK
* KLayout
* Magic
* STA
