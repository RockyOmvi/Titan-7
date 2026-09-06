# Titan-7 Silicon Mask & KLayout Physical Design Package

Welcome to the **Titan-7 7nm FinFET ASIC Physical Layout Package**. This directory contains the complete physical layout stream files, layer property definitions, high-resolution silicon mask renderings, and interactive viewers.

---

## 📁 Directory Contents

| File | Type | Description |
| :--- | :--- | :--- |
| **[`titan7_flagship_chip.gds`](file:///d:/ChipAI/klayout/titan7_flagship_chip.gds)** | GDSII Stream (21.4 MB) | Full-chip physical layout stream containing all standard cells, power rings, pin arrays, and routing tracks. |
| **[`asap7_layers.lyp`](file:///d:/ChipAI/klayout/asap7_layers.lyp)** | KLayout Layer Palette | XML layer property file defining colors and stipples for ASAP7 FinFET layers (Active, Poly, M1–M9, Pads). |
| **[`index.html`](file:///d:/ChipAI/klayout/index.html)** | Interactive Web Viewer | Browser-based KLayout CAD tool with zoom, pan, layer toggles, micron coordinate HUD, and macro inspection. |
| **[`klayout_full_chip_layout.png`](file:///d:/ChipAI/klayout/klayout_full_chip_layout.png)** | High-Res PNG (1920x1080) | Headless KLayout render showing full silicon mask, standard cell rows, and IO bond pads. |
| **[`klayout_die_floorplan.png`](file:///d:/ChipAI/klayout/klayout_die_floorplan.png)** | 300 DPI Publication Plan | 16x12" detailed floorplan map with power grid, UCIe PHY, and macro dimensions. |
| **[`open_klayout.bat`](file:///d:/ChipAI/klayout/open_klayout.bat)** | 1-Click Launcher | Automatically opens the layout in your browser or in desktop KLayout GUI. |

---

## 🚀 How to View the Layout

### 1. Interactive Web KLayout Viewer (No Installation Required)
Double-click **[`open_klayout.bat`](file:///d:/ChipAI/klayout/open_klayout.bat)** or open **[`index.html`](file:///d:/ChipAI/klayout/index.html)** in any web browser.
- **Zoom / Pan**: Scroll mouse wheel to zoom; click and drag to pan across the die.
- **Fit View**: Press **`F`** or click the **`⛶ Fit View`** button.
- **Layer Toggle**: Use the right sidebar to enable/disable metal layers and inspect macros.
- **Coordinate HUD**: Hover cursor anywhere on the chip to see exact silicon coordinates in micrometers ($\mu m$).

### 2. Using Desktop KLayout GUI
If you have KLayout installed on your workstation:
```cmd
klayout titan7_flagship_chip.gds -l asap7_layers.lyp
```

### 3. Headless KLayout via OpenLane Docker
To re-render or run DRC/LVS through the containerized OpenLane KLayout engine:
```cmd
docker run --rm -v "d:\ChipAI\klayout:/work" -w /work efabless/openlane:latest klayout -b -r render_script.py
```

---

## 🔬 Silicon Hierarchy & Subsystems

1. **8-Core Coherent CPU Cluster**:
   - 2x Prime Out-of-Order RV64 Cores (Gshare predictor, 64 PRF, 16 ROB entries).
   - 6x Efficient Pipelined RV32/64 Cores with Hardware Mutex unit.
2. **1,024-Lane Vector SIMD GPU**:
   - 32 Compute Units $\times$ 32 SIMD Lanes = 1,024 concurrent ALUs (2.048 TFLOPS @ 1.0 GHz).
3. **64-PE Systolic Array NPU**:
   - 8 $\times$ 8 INT8 matrix multiply mesh for on-device neural acceleration (32 TOPS).
4. **3GPP Rel-17 5G NR Baseband Modem**:
   - Pipelined Radix-2 FFT/IFFT butterfly engine + Min-Sum LDPC decoder ($s = c \cdot H^T = 0$).
5. **30MB Sliced Coherent L3 / SLC Cache**:
   - Multi-bank directory with MESI snooping protocol and DRAM fill engine.
6. **UCIe 1.0 3D Die-to-Die Interface**:
   - 16-lane D2D PHY delivering 32 Gbps/pin for multi-chiplet packaging.
