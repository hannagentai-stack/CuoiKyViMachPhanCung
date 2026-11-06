#=============================================================================
# SCRIPT CHAY MO PHONG NHANH TREN MODELSIM 20.1 CHO CAU 3
# Chay trong ModelSim: vsim -do run_sim.do
#=============================================================================

vlib work
vcom -93 -work work dem_len_mod9.vhd
vcom -93 -work work tb_dem_len_mod9.vhd

vsim -t 1ns work.tb_dem_len_mod9

add wave -divider "CLOCK & RESET"
add wave -format Logic /tb_dem_len_mod9/s_clk
add wave -format Logic /tb_dem_len_mod9/s_rst_n

add wave -divider "INPUT CONTROL"
add wave -format Logic /tb_dem_len_mod9/s_nut
add wave -format Logic /tb_dem_len_mod9/s_tudong

add wave -divider "INTERNAL SIGNALS"
add wave -format Logic /tb_dem_len_mod9/uut/btn_clean
add wave -format Logic /tb_dem_len_mod9/uut/en_tay
add wave -format Logic /tb_dem_len_mod9/uut/en_tudong
add wave -format Logic /tb_dem_len_mod9/uut/en_count

add wave -divider "OUTPUTS"
add wave -format Literal -radix unsigned /tb_dem_len_mod9/s_Q
add wave -format Logic /tb_dem_len_mod9/s_bao
add wave -format Literal -radix binary /tb_dem_len_mod9/s_HEX0

run 2500 ns
wave zoom full
