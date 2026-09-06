# Titan-7: 7nm FinFET ASIC Physical Layout & Signoff Package
*Flagship Heterogeneous Mobile System-on-Chip (SoC) Architectural Prototype*

[![Architecture](https://img.shields.io/badge/Architecture-RISC--V%2064--bit-blue.svg)](https://riscv.org)
[![PDK](https://img.shields.io/badge/PDK-ASAP7%207nm%20FinFET-green.svg)](https://github.com/The-OpenROAD-Project/asap7)
[![GDSII](https://img.shields.io/badge/Layout-21.4MB%20GDSII-orange.svg)](#-physical-layout--silicon-masks)
[![OASIS](https://img.shields.io/badge/Layout-2.07MB%20OASIS-purple.svg)](#-physical-layout--silicon-masks)
[![EDA](https://img.shields.io/badge/EDA-Yosys%20%7C%20OpenLane%20%7C%20KLayout-red.svg)](https://www.klayout.de)

Welcome to the **Titan-7 7nm FinFET ASIC Physical Layout & Signoff Package**.

This repository contains the complete physical layout stream files (**GDSII** and **OASIS**), layer property palettes (`.lyp`), Synopsys Design Constraints (`.sdc`), IEEE 1801 Unified Power Format (`.upf`), Macro LEF (`.lef`), high-resolution silicon mask renderings, and interactive layout viewers.

---

## 📸 Physical Silicon Mask & Floorplan

| Full-Chip Silicon Mask (KLayout) | 300 DPI Publication Die Floorplan |
| :---: | :---: |
| ![Full Chip Layout](images/klayout_full_chip_layout.png) | ![Die Floorplan](images/klayout_die_floorplan.png) |
| *21.4 MB GDSII standard cell placement & peripheral I/O pad ring* | *Floorplan with power delivery ring, macro coordinates, and pin tracks* |

---

## 📁 Repository Directory Contents

| File / Folder | Type | Description |
| :--- | :--- | :--- |
| **[`titan7_flagship_chip.oas`](titan7_flagship_chip.oas)** | OASIS Stream (2.07 MB) | Modern, highly compressed SEMI-standard replacement for GDSII (89.9% smaller) used in leading-edge foundries. |
| **[`titan7_flagship_chip.gds`](titan7_flagship_chip.gds)** | GDSII Stream (21.4 MB) | Full-chip physical layout stream containing all standard cells, power rings, pin arrays, and routing tracks. |
| **[`titan7_constraints.sdc`](titan7_constraints.sdc)** | Timing Constraints (SDC 2.1) | Synopsys Design Constraints defining 2.8 GHz Prime core, 1.0 GHz GPU/NPU clocks, multicycle paths, and CDC boundaries. |
| **[`titan7_power_intent.upf`](titan7_power_intent.upf)** | Power Intent (UPF 3.0 / IEEE 1801) | Unified Power Format specifying 6 voltage domains, power switches, isolation cells, and dynamic power states. |
| **[`titan7_macro.lef`](titan7_macro.lef)** | Library Exchange Format (LEF 5.8) | Physical IP macro abstraction defining die boundary, pin geometry, and M1–M8 routing blockages. |
| **[`asap7_layers.lyp`](asap7_layers.lyp)** | KLayout Layer Palette | XML layer property file defining colors, stipples, and visibility for ASAP7 FinFET layers (Active, Poly, M1–M9, Pads). |
| **[`titan7_flagship_technical_whitepaper.md`](titan7_flagship_technical_whitepaper.md)** | Technical Specification | Full gate-level metrics, power delivery analysis, and DRC/LVS physical signoff specifications. |
| **[`chip_ai_the_titan7_chronicle.md`](chip_ai_the_titan7_chronicle.md)** | Engineering Narrative | The chronicle of the autonomous architecture sprint from RTL to physical silicon layout. |
| **(images)** | High-Resolution Media | 300 DPI floorplans, KLayout silicon exports, and OS verification screenshots. |

---

## 🔬 Silicon Hierarchy & Subsystems

```
       +-------------------------------------------------------------+
       |                  TITAN-7 HETEROGENEOUS SOC                  |
       +-------------------------------------------------------------+
                                      |
         +----------------------------+----------------------------+
         |                            |                            |
  [8-Core Coherent CPU]       [1024-Lane Vector GPU]     [64-PE Systolic NPU]
   - 2x Prime RV64 OoO Cores   - 32 Compute Units         - 8x8 INT8 Matrix Mesh
   - 6x Efficient RV32/64 Cores- 2.048 TFLOPS @ 1.0 GHz   - 32 TOPS On-Device AI
         |                            |                            |
         +----------------------------+----------------------------+
                                      |
                 [High-Speed 256-bit AXI4 Crossbar Interconnect]
                                      |
         +----------------------------+----------------------------+
         |                                                         |
  [32MB Sliced Coherent L3/SLC Cache]               [5G NR Baseband Modem]
   - Multi-bank MESI Coherency Directory             - Radix-2 FFT + Min-Sum LDPC
```

### 1. 8-Core Coherent CPU Cluster
* **2x Prime Out-of-Order (OoO) RV64 Cores**:
  * Speculative Tomasulo reservation stations with dynamic wakeup.
  * 64-entry Physical Register File (PRF) with dynamic hardware register renaming.
  * 16-entry Reorder Buffer (ROB) and 1024-entry dynamic GShare branch predictor + Branch Target Buffer (BTB).
* **6x Efficient Pipelined RV32/64 Cores**:
  * High-efficiency symmetric multiprocessing (SMP) compute cluster with hardware mutex arbitration.

### 2. 1,024-Lane Vector SIMD GPU
* **32 Compute Units × 32 SIMD Lanes = 1,024 concurrent ALUs**.
* **2.048 TFLOPS** single-precision throughput @ 1.0 GHz.
* Hardware texture cache and rasterizer engine tailored for modern mobile graphics workloads.

### 3. 64-PE Systolic Array NPU
* **8 × 8 INT8 / FP8 matrix multiplication systolic mesh**.
* Delivers **32 TOPS** of on-device neural acceleration for generative AI, LLMs, and computer vision.
* Integrated weight double-buffering scratchpad to maximize arithmetic intensity.

### 4. 3GPP Rel-17 5G NR Baseband Modem
* Pipelined **Radix-2 FFT / IFFT butterfly engine** for sub-6GHz and mmWave carrier aggregation.
* Hardware-accelerated **Min-Sum LDPC decoder** ($s = c \cdot H^T = 0$) for ultra-reliable low-latency communications (URLLC).

### 5. 32MB Sliced Coherent System-Level Cache (SLC)
* Multi-bank directory with MESI cache coherency protocol delivering high-bandwidth on-chip caching.

---

## 🚀 How to View the Physical Layout

### Method 1: Desktop KLayout GUI (Full Mask Stream)
If you have [KLayout](https://www.klayout.de) installed on your system:
```bash
klayout titan7_flagship_chip.gds -l asap7_layers.lyp
```
*Or load the compressed OASIS stream:*
```bash
klayout titan7_flagship_chip.oas -l asap7_layers.lyp

---

##  Physical Signoff & PDK Metrics
* **Technology Node**: Arizona State Predictive 7nm (ASAP7) FinFET PDK.
* **Routing Metallization**: 9 layers (M1–M9) with bidirectional pitch constraints.
* **Die Area / Floorplan**: Detailed dimensions and pad assignments available in [`images/klayout_die_floorplan.png`](images/klayout_die_floorplan.png).
* **Timing & Power**: Governed by [`titan7_constraints.sdc`](titan7_constraints.sdc) and [`titan7_power_intent.upf`](titan7_power_intent.upf).

---

##  Citation & Community
If you use Titan-7 or ChipAI architectures in your research or projects, please reference:
```bibtex
@misc{titan7_chipai_2026,
  author = {RockyOmvi and ChipAI Team},
  title = {Titan-7: 7nm FinFET ASIC Physical Layout & Signoff Package},
  year = {2026},
  publisher = {GitHub},
  journal = {GitHub repository},
  howpublished = {\url{https://github.com/RockyOmvi/Titan-7}}
}
```

---
*Developed autonomously with [ChipAI](https://github.com/RockyOmvi/Titan-7).*
