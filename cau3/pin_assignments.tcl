#=============================================================================
# SCRIPT TCL GAN CHAN KIT DE2-115 CHO CAU 3 - DE SO 2
# Chay trong Quartus Prime: Tools -> Tcl Scripts -> Chon file nay va bam Run
# Hoac chay trong Quartus Tcl Console: source pin_assignments.tcl
#=============================================================================

# 1. Xung nhip he thong CLOCK_50 (Dung chuan 3.3-V LVTTL)
set_location_assignment PIN_Y2 -to clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk

# 2. Nut nhan KEY0 (Reset bat dong bo, muc thap) va KEY1 (Dem tay)
set_location_assignment PIN_M23 -to rst_n
set_instance_assignment -name IO_STANDARD "2.5 V" -to rst_n

set_location_assignment PIN_M21 -to nut
set_instance_assignment -name IO_STANDARD "2.5 V" -to nut

# 3. Cong tac gat SW1 (Chon che do tay/tu dong)
set_location_assignment PIN_AC28 -to tudong
set_instance_assignment -name IO_STANDARD "2.5 V" -to tudong

# 4. LED do hien thi gia tri dem Q(3 downto 0) tren LEDR3..LEDR0
set_location_assignment PIN_F21 -to Q[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to Q[3]

set_location_assignment PIN_E19 -to Q[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to Q[2]

set_location_assignment PIN_F19 -to Q[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to Q[1]

set_location_assignment PIN_G19 -to Q[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to Q[0]

# 5. LED xanh bao gia tri max (8) tren LEDG0
set_location_assignment PIN_E21 -to bao
set_instance_assignment -name IO_STANDARD "2.5 V" -to bao

# 6. LED 7 doan HEX0 (Doan g den a: HEX0[6]..HEX0[0])
set_location_assignment PIN_H22 -to HEX0[6]
set_instance_assignment -name IO_STANDARD "2.5 V" -to HEX0[6]

set_location_assignment PIN_J22 -to HEX0[5]
set_instance_assignment -name IO_STANDARD "2.5 V" -to HEX0[5]

set_location_assignment PIN_L25 -to HEX0[4]
set_instance_assignment -name IO_STANDARD "2.5 V" -to HEX0[4]

set_location_assignment PIN_L26 -to HEX0[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to HEX0[3]

set_location_assignment PIN_E17 -to HEX0[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to HEX0[2]

set_location_assignment PIN_F22 -to HEX0[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to HEX0[1]

set_location_assignment PIN_G18 -to HEX0[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to HEX0[0]

# Cau hinh chan khong dung ve trang thai ba trang thai (Tri-state) an toan
set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED WITH WEAK PULL-UP"
