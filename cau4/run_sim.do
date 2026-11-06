#=============================================================================
# SCRIPT CHAY MO PHONG NHANH TREN MODELSIM 20.1 CHO CAU 4
# Chay trong ModelSim: vsim -do run_sim.do
#=============================================================================

vlib work
vcom -93 -work work dk_dong_co.vhd
vcom -93 -work work tb_dk_dong_co.vhd

vsim -t 1ns work.tb_dk_dong_co

add wave -divider "CLOCK & RESET"
add wave -format Logic /tb_dk_dong_co/s_clk
add wave -format Logic /tb_dk_dong_co/s_rst_n

add wave -divider "SWITCH CONTROL"
add wave -format Logic /tb_dk_dong_co/s_SW(17)
add wave -format Literal -radix binary /tb_dk_dong_co/s_SW(1 downto 0)

add wave -divider "L298 OUTPUTS"
add wave -format Logic /tb_dk_dong_co/s_ENA
add wave -format Logic /tb_dk_dong_co/s_IN1
add wave -format Logic /tb_dk_dong_co/s_IN2

add wave -divider "INTERNAL SIGNALS"
add wave -format Literal -radix unsigned /tb_dk_dong_co/uut/duty
add wave -format Literal -radix unsigned /tb_dk_dong_co/uut/nac
add wave -format Logic /tb_dk_dong_co/uut/chieu

run 40 us
wave zoom full
