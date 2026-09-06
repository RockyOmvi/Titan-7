################################################################################
# Design Name       : titan7_mobile_soc_top
# Target Library    : ASAP7_75t_LVT_R1.0 (7nm Predictive FinFET)
# Operating Corner  : SSG_0.65V_125C (Slow-Slow-Global Worst-Case Setup)
# SDC Version       : 2.1 (IEEE 1481)
# Signoff Mode      : Mission-Critical Automotive / High-Performance Mobile
################################################################################

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA

# -----------------------------------------------------------------------------
# 1. CLOCK DEFINITIONS & JITTER BUDGETS
# -----------------------------------------------------------------------------
create_clock -name CLK_CORE_PRIME -period 0.357 -waveform {0.000 0.178} [get_ports clk_core_prime]
create_clock -name CLK_CORE_EFF   -period 0.555 -waveform {0.000 0.277} [get_ports clk_core_eff]
create_clock -name CLK_GPU        -period 1.000 -waveform {0.000 0.500} [get_ports clk_gpu]
create_clock -name CLK_NPU        -period 1.000 -waveform {0.000 0.500} [get_ports clk_npu]
create_clock -name CLK_AXI        -period 1.250 -waveform {0.000 0.625} [get_ports clk_axi_main]
create_clock -name CLK_UCIE       -period 0.500 -waveform {0.000 0.250} [get_ports clk_ucie_phy]
create_clock -name CLK_SLC        -period 0.714 -waveform {0.000 0.357} [get_ports clk_slc]

# 7nm FinFET Jitter, PLL Wander & Clock Tree Skew Budget
set_clock_uncertainty -setup 0.035 [all_clocks]
set_clock_uncertainty -hold  0.015 [all_clocks]
set_clock_transition -rise 0.025 [all_clocks]
set_clock_transition -fall 0.025 [all_clocks]

# -----------------------------------------------------------------------------
# 2. ADVANCED ON-CHIP VARIATION (AOCV) / TIMING DERATE
# -----------------------------------------------------------------------------
set_timing_derate -early 0.95 -cell_delay
set_timing_derate -late  1.05 -cell_delay
set_timing_derate -early 0.97 -net_delay
set_timing_derate -late  1.03 -net_delay

# -----------------------------------------------------------------------------
# 3. ASYNCHRONOUS CLOCK DOMAIN CROSSINGS (CDC)
# -----------------------------------------------------------------------------
set_clock_groups -asynchronous \
    -group [get_clocks CLK_CORE_PRIME] \
    -group [get_clocks CLK_CORE_EFF] \
    -group [get_clocks CLK_GPU] \
    -group [get_clocks CLK_NPU] \
    -group [get_clocks CLK_AXI] \
    -group [get_clocks CLK_UCIE] \
    -group [get_clocks CLK_SLC]

# -----------------------------------------------------------------------------
# 4. IO CONSTRAINTS & PORT TIMING
# -----------------------------------------------------------------------------
set_driving_cell -lib_cell BUFx4_ASAP7_75t_L -library asap7sc7p5t_27_L_SS [all_inputs]
set_load -pin_load 0.008 [all_outputs]

# System AXI Bus Interface Delays
set_input_delay  -clock CLK_AXI -max 0.375 [get_ports {axi_s_*}]
set_input_delay  -clock CLK_AXI -min 0.080 [get_ports {axi_s_*}]
set_output_delay -clock CLK_AXI -max 0.375 [get_ports {axi_m_*}]
set_output_delay -clock CLK_AXI -min 0.080 [get_ports {axi_m_*}]

# UCIe 1.0 Die-to-Die Interface Delays
set_input_delay  -clock CLK_UCIE -max 0.120 [get_ports {ucie_rx_data[*]}]
set_input_delay  -clock CLK_UCIE -min 0.030 [get_ports {ucie_rx_data[*]}]
set_output_delay -clock CLK_UCIE -max 0.120 [get_ports {ucie_tx_data[*]}]
set_output_delay -clock CLK_UCIE -min 0.030 [get_ports {ucie_tx_data[*]}]

# -----------------------------------------------------------------------------
# 5. EXCEPTIONS & MULTICYCLE PATHS
# -----------------------------------------------------------------------------
set_false_path -from [get_ports {rst_n test_mode scan_en}]

# 3-Stage Pipelined Vector FPU Execution Units
set_multicycle_path 3 -setup -from [get_pins -hierarchical *fma_pipe*/clk] -to [get_pins -hierarchical *fma_pipe*/D]
set_multicycle_path 2 -hold  -from [get_pins -hierarchical *fma_pipe*/clk] -to [get_pins -hierarchical *fma_pipe*/D]

# 2-Stage Matrix Systolic PE Register Propagation
set_multicycle_path 2 -setup -from [get_pins -hierarchical *u_npu_systolic*/*pe_reg*/clk] -to [get_pins -hierarchical *u_npu_systolic*/*pe_reg*/D]
set_multicycle_path 1 -hold  -from [get_pins -hierarchical *u_npu_systolic*/*pe_reg*/clk] -to [get_pins -hierarchical *u_npu_systolic*/*pe_reg*/D]

# -----------------------------------------------------------------------------
# 6. DESIGN RULE CONSTRAINTS (DRC LIMITS)
# -----------------------------------------------------------------------------
set_max_fanout 16 [current_design]
set_max_transition 0.075 [current_design]
set_max_capacitance 0.050 [current_design]
