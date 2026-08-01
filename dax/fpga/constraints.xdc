# DAX — Dual Address eXtension
# Local design constraints for top-level DAX FPGA module
# This file is test-only and proprietary to Thomas.

# --------------------------------------------------------------------
# 1. Clocks
# --------------------------------------------------------------------

# Assume main user clock comes from board clock net (already defined in U55C_xdc_1v00.xdc)
# Here we just constrain the internal DAX clock if you buffer or derive it.

create_clock -name dax_clk -period 3.333 [get_pins {dax_top_i/clk_buf/O}]
# 300 MHz example — adjust to match your actual design

# Optional: generated clocks (if you use MMCM/PLL)
# create_generated_clock -name dax_clk_div2 -source [get_clocks dax_clk] \
#     -divide_by 2 [get_pins {dax_top_i/clk_div2_reg/Q}]

# --------------------------------------------------------------------
# 2. Resets
# --------------------------------------------------------------------

# Declare reset as asynchronous, then synchronize in RTL
set_false_path -from [get_ports rst_n] -to [get_clocks dax_clk]

# --------------------------------------------------------------------
# 3. AXI-Lite / Control Path
# --------------------------------------------------------------------

# Relax timing on debug/status paths if needed
# Example: if you have slow status signals crossing clock domains

# set_false_path -from [get_cells {axi_lite_dax_ctrl_i/status_reg[*]}] \
#                -to   [get_cells {dax_meu_i/*}]

# --------------------------------------------------------------------
# 4. DAX MEU / Memory Paths
# --------------------------------------------------------------------

# If you have long XOR trees or wide buses, you may want to guide timing:

# set_max_delay -from [get_cells {dax_meu_i/master_mem_reg[*]}] \
#               -to   [get_cells {dax_meu_i/delta_mem_reg[*]}] 5.0

# Or explicitly mark non-critical debug paths:
# set_false_path -from [get_cells {dax_meu_i/debug_*}] -to [get_clocks dax_clk]

# --------------------------------------------------------------------
# 5. Simulation-only / Test-only nets
# --------------------------------------------------------------------

# Any nets used only for testbench visibility can be relaxed:
# set_false_path -from [get_cells {tb_*}] -to [get_clocks dax_clk]

# --------------------------------------------------------------------
# NOTE:
# - All board-level pins, PCIe, HBM, and global clocks are defined
#   in the official U55C_xdc_1v00.xdc from AMD/Xilinx.
# - This file is ONLY for your local DAX design constraints.
# - Do NOT replace the vendor XDC; include both in the Vivado project.
