#=============================================================================
# SCRIPT CHAY MO PHONG NHANH TREN MODELSIM 20.1 CHO CAU 2
# Chay trong ModelSim: vsim -do run_sim.do
#=============================================================================

vlib work
vcom -93 -work work ma_hoa_8_3.vhd
vcom -93 -work work tb_ma_hoa_8_3.vhd

vsim -t 1ns work.tb_ma_hoa_8_3

add wave -divider "INPUT I(7..0)"
add wave -format Literal -radix binary /tb_ma_hoa_8_3/s_I

add wave -divider "OUTPUTS"
add wave -format Literal -radix binary /tb_ma_hoa_8_3/s_Y
add wave -format Logic /tb_ma_hoa_8_3/s_V

run 300 ns
wave zoom full
