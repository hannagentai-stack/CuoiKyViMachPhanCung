#=============================================================================
# SCRIPT CHAY MO PHONG NHANH TREN MODELSIM 20.1 CHO CAU 1
# Chay trong ModelSim: vsim -do run_sim.do
#=============================================================================

vlib work
vcom -93 -work work ham_k.vhd
vcom -93 -work work tb_ham_k.vhd

vsim -t 1ns work.tb_ham_k

add wave -divider "INPUTS"
add wave -format Logic /tb_ham_k/s_A
add wave -format Logic /tb_ham_k/s_B
add wave -format Logic /tb_ham_k/s_C
add wave -format Logic /tb_ham_k/s_D

add wave -divider "OUTPUT"
add wave -format Logic /tb_ham_k/s_K

run 200 ns
wave zoom full
