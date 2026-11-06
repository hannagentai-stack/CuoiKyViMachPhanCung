#=============================================================================
# SCRIPT TCL GAN CHAN KIT DE2-115 CHO CAU 2 - DE SO 2
# Chay trong Quartus Prime: Tools -> Tcl Scripts -> Chon file nay va bam Run
# Hoac chay trong Quartus Tcl Console: source pin_assignments.tcl
#=============================================================================

# Gan chan cho 8 cong tac dau vao I(7 downto 0) tu SW7 den SW0
set_location_assignment PIN_AB26 -to I[7]
set_instance_assignment -name IO_STANDARD "2.5 V" -to I[7]

set_location_assignment PIN_AD26 -to I[6]
set_instance_assignment -name IO_STANDARD "2.5 V" -to I[6]

set_location_assignment PIN_AC26 -to I[5]
set_instance_assignment -name IO_STANDARD "2.5 V" -to I[5]

set_location_assignment PIN_AB27 -to I[4]
set_instance_assignment -name IO_STANDARD "2.5 V" -to I[4]

set_location_assignment PIN_AD27 -to I[3]
set_instance_assignment -name IO_STANDARD "2.5 V" -to I[3]

set_location_assignment PIN_AC27 -to I[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to I[2]

set_location_assignment PIN_AC28 -to I[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to I[1]

set_location_assignment PIN_AB28 -to I[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to I[0]

# Gan chan cho dau ra ma hoa Y(2 downto 0) tren LEDR2..LEDR0
set_location_assignment PIN_E19 -to Y[2]
set_instance_assignment -name IO_STANDARD "2.5 V" -to Y[2]

set_location_assignment PIN_F19 -to Y[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to Y[1]

set_location_assignment PIN_G19 -to Y[0]
set_instance_assignment -name IO_STANDARD "2.5 V" -to Y[0]

# Gan chan cho dau ra hop le V tren LEDG0
set_location_assignment PIN_E21 -to V
set_instance_assignment -name IO_STANDARD "2.5 V" -to V

# Cau hinh chan khong dung ve trang thai ba trang thai (Tri-state) an toan
set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED WITH WEAK PULL-UP"
