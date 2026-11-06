#=============================================================================
# SCRIPT TCL GAN CHAN KIT DE2-115 CHO CAU 1 - DE SO 2
# Chay trong Quartus Prime: Tools -> Tcl Scripts -> Chon file nay va bam Run
# Hoac chay trong Quartus Tcl Console: source pin_assignments.tcl
#=============================================================================

# Xoa cac gan chan cu (neu co)
# set_global_assignment -name FAMILY "Cyclone IV E"
# set_global_assignment -name DEVICE EP4CE115F29C7

# Gan chan cho 4 cong tac SW3, SW2, SW1, SW0 (A, B, C, D)
set_location_assignment PIN_AD27 -to A
set_instance_assignment -name IO_STANDARD "2.5 V" -to A

set_location_assignment PIN_AC27 -to B
set_instance_assignment -name IO_STANDARD "2.5 V" -to B

set_location_assignment PIN_AC28 -to C
set_instance_assignment -name IO_STANDARD "2.5 V" -to C

set_location_assignment PIN_AB28 -to D
set_instance_assignment -name IO_STANDARD "2.5 V" -to D

# Gan chan cho dau ra K (LEDR0)
set_location_assignment PIN_G19 -to K
set_instance_assignment -name IO_STANDARD "2.5 V" -to K

# Cau hinh chan khong dung ve trang thai ba trang thai (Tri-state) an toan
set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED WITH WEAK PULL-UP"
