## Generated SDC file "lab8.out.sdc"

## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus II License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 15.0.2 Build 153 07/15/2015 SJ Full Version"

## DATE    "Thu Mar 15 13:44:36 2018"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {main_clk_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {nios_system|sdram_pll|sd1|pll7|clk[0]} -source [get_pins {nios_system|sdram_pll|sd1|pll7|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -phase -54.000 -master_clock {main_clk_50} [get_pins {nios_system|sdram_pll|sd1|pll7|clk[0]}] 
create_generated_clock -name {nios_system|sdram_pll|sd1|pll7|clk[1]} -source [get_pins {nios_system|sdram_pll|sd1|pll7|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -phase -54.000 -master_clock {main_clk_50} [get_pins {nios_system|sdram_pll|sd1|pll7|clk[1]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {main_clk_50}]  0.150  
set_clock_uncertainty -rise_from [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {main_clk_50}]  0.150  
set_clock_uncertainty -fall_from [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}] -rise_to [get_clocks {main_clk_50}]  0.150  
set_clock_uncertainty -fall_from [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}] -fall_to [get_clocks {main_clk_50}]  0.150  
set_clock_uncertainty -rise_from [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[1]}] -rise_to [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  0.010  
set_clock_uncertainty -rise_from [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[1]}] -fall_to [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  0.010  
set_clock_uncertainty -fall_from [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[1]}] -rise_to [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  0.010  
set_clock_uncertainty -fall_from [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[1]}] -fall_to [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  0.010  
set_clock_uncertainty -rise_from [get_clocks {main_clk_50}] -rise_to [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  0.150  
set_clock_uncertainty -rise_from [get_clocks {main_clk_50}] -fall_to [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  0.150  
set_clock_uncertainty -rise_from [get_clocks {main_clk_50}] -rise_to [get_clocks {main_clk_50}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {main_clk_50}] -fall_to [get_clocks {main_clk_50}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {main_clk_50}] -rise_to [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  0.150  
set_clock_uncertainty -fall_from [get_clocks {main_clk_50}] -fall_to [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  0.150  
set_clock_uncertainty -fall_from [get_clocks {main_clk_50}] -rise_to [get_clocks {main_clk_50}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {main_clk_50}] -fall_to [get_clocks {main_clk_50}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[0]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[0]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[1]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[1]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[2]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[2]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[3]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[3]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[4]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[4]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[5]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[5]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[6]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[6]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[7]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[7]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[8]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[8]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[9]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[9]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[10]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[10]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[11]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[11]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[12]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[12]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[13]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[13]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[14]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[14]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[15]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[15]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[16]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[16]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[17]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[17]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[18]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[18]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[19]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[19]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[20]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[20]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[21]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[21]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[22]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[22]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[23]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[23]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[24]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[24]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[25]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[25]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[26]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[26]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[27]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[27]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[28]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[28]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[29]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[29]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[30]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[30]}]
set_input_delay -add_delay -max -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  3.000 [get_ports {DRAM_DQ[31]}]
set_input_delay -add_delay -min -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[31]}]
set_input_delay -add_delay -max -clock [get_clocks {main_clk_50}]  3.000 [get_ports {KEY[0]}]
set_input_delay -add_delay -min -clock [get_clocks {main_clk_50}]  2.000 [get_ports {KEY[0]}]
set_input_delay -add_delay -max -clock [get_clocks {main_clk_50}]  3.000 [get_ports {KEY[1]}]
set_input_delay -add_delay -min -clock [get_clocks {main_clk_50}]  2.000 [get_ports {KEY[1]}]
set_input_delay -add_delay -max -clock [get_clocks {main_clk_50}]  3.000 [get_ports {KEY[2]}]
set_input_delay -add_delay -min -clock [get_clocks {main_clk_50}]  2.000 [get_ports {KEY[2]}]
set_input_delay -add_delay -max -clock [get_clocks {main_clk_50}]  3.000 [get_ports {KEY[3]}]
set_input_delay -add_delay -min -clock [get_clocks {main_clk_50}]  2.000 [get_ports {KEY[3]}]
set_input_delay -add_delay -max -clock [get_clocks {main_clk_50}]  3.000 [get_ports {altera_reserved_tck}]
set_input_delay -add_delay -min -clock [get_clocks {main_clk_50}]  2.000 [get_ports {altera_reserved_tck}]
set_input_delay -add_delay -max -clock [get_clocks {main_clk_50}]  3.000 [get_ports {altera_reserved_tdi}]
set_input_delay -add_delay -min -clock [get_clocks {main_clk_50}]  2.000 [get_ports {altera_reserved_tdi}]
set_input_delay -add_delay -max -clock [get_clocks {main_clk_50}]  3.000 [get_ports {altera_reserved_tms}]
set_input_delay -add_delay -min -clock [get_clocks {main_clk_50}]  2.000 [get_ports {altera_reserved_tms}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_ADDR[0]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_ADDR[1]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_ADDR[2]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_ADDR[3]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_ADDR[4]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_ADDR[5]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_ADDR[6]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_ADDR[7]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_ADDR[8]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_ADDR[9]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_ADDR[10]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_ADDR[11]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_ADDR[12]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_BA[0]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_BA[1]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_CAS_N}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_CKE}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_CLK}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_CS_N}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQM[0]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQM[1]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQM[2]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQM[3]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[0]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[1]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[2]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[3]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[4]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[5]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[6]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[7]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[8]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[9]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[10]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[11]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[12]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[13]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[14]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[15]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[16]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[17]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[18]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[19]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[20]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[21]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[22]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[23]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[24]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[25]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[26]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[27]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[28]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[29]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[30]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_DQ[31]}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_RAS_N}]
set_output_delay -add_delay  -clock [get_clocks {nios_system|sdram_pll|sd1|pll7|clk[0]}]  2.000 [get_ports {DRAM_WE_N}]
set_output_delay -add_delay  -clock [get_clocks {main_clk_50}]  2.000 [get_ports {altera_reserved_tdo}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_registers {*|alt_jtag_atlantic:*|jupdate}] -to [get_registers {*|alt_jtag_atlantic:*|jupdate1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rdata[*]}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read}] -to [get_registers {*|alt_jtag_atlantic:*|read1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|read_req}] 
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|rvalid}] -to [get_registers {*|alt_jtag_atlantic*|td_shift[*]}]
set_false_path -from [get_registers {*|t_dav}] -to [get_registers {*|alt_jtag_atlantic:*|tck_t_dav}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|user_saw_rvalid}] -to [get_registers {*|alt_jtag_atlantic:*|rvalid0*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|wdata[*]}] -to [get_registers *]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write}] -to [get_registers {*|alt_jtag_atlantic:*|write1*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_ena*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_stalled}] -to [get_registers {*|alt_jtag_atlantic:*|t_pause*}]
set_false_path -from [get_registers {*|alt_jtag_atlantic:*|write_valid}] 
set_false_path -from [get_keepers {*nios_system_nios2_gen2_0_cpu:*|nios_system_nios2_gen2_0_cpu_nios2_oci:the_nios_system_nios2_gen2_0_cpu_nios2_oci|nios_system_nios2_gen2_0_cpu_nios2_oci_break:the_nios_system_nios2_gen2_0_cpu_nios2_oci_break|break_readreg*}] -to [get_keepers {*nios_system_nios2_gen2_0_cpu:*|nios_system_nios2_gen2_0_cpu_nios2_oci:the_nios_system_nios2_gen2_0_cpu_nios2_oci|nios_system_nios2_gen2_0_cpu_debug_slave_wrapper:the_nios_system_nios2_gen2_0_cpu_debug_slave_wrapper|nios_system_nios2_gen2_0_cpu_debug_slave_tck:the_nios_system_nios2_gen2_0_cpu_debug_slave_tck|*sr*}]
set_false_path -from [get_keepers {*nios_system_nios2_gen2_0_cpu:*|nios_system_nios2_gen2_0_cpu_nios2_oci:the_nios_system_nios2_gen2_0_cpu_nios2_oci|nios_system_nios2_gen2_0_cpu_nios2_oci_debug:the_nios_system_nios2_gen2_0_cpu_nios2_oci_debug|*resetlatch}] -to [get_keepers {*nios_system_nios2_gen2_0_cpu:*|nios_system_nios2_gen2_0_cpu_nios2_oci:the_nios_system_nios2_gen2_0_cpu_nios2_oci|nios_system_nios2_gen2_0_cpu_debug_slave_wrapper:the_nios_system_nios2_gen2_0_cpu_debug_slave_wrapper|nios_system_nios2_gen2_0_cpu_debug_slave_tck:the_nios_system_nios2_gen2_0_cpu_debug_slave_tck|*sr[33]}]
set_false_path -from [get_keepers {*nios_system_nios2_gen2_0_cpu:*|nios_system_nios2_gen2_0_cpu_nios2_oci:the_nios_system_nios2_gen2_0_cpu_nios2_oci|nios_system_nios2_gen2_0_cpu_nios2_oci_debug:the_nios_system_nios2_gen2_0_cpu_nios2_oci_debug|monitor_ready}] -to [get_keepers {*nios_system_nios2_gen2_0_cpu:*|nios_system_nios2_gen2_0_cpu_nios2_oci:the_nios_system_nios2_gen2_0_cpu_nios2_oci|nios_system_nios2_gen2_0_cpu_debug_slave_wrapper:the_nios_system_nios2_gen2_0_cpu_debug_slave_wrapper|nios_system_nios2_gen2_0_cpu_debug_slave_tck:the_nios_system_nios2_gen2_0_cpu_debug_slave_tck|*sr[0]}]
set_false_path -from [get_keepers {*nios_system_nios2_gen2_0_cpu:*|nios_system_nios2_gen2_0_cpu_nios2_oci:the_nios_system_nios2_gen2_0_cpu_nios2_oci|nios_system_nios2_gen2_0_cpu_nios2_oci_debug:the_nios_system_nios2_gen2_0_cpu_nios2_oci_debug|monitor_error}] -to [get_keepers {*nios_system_nios2_gen2_0_cpu:*|nios_system_nios2_gen2_0_cpu_nios2_oci:the_nios_system_nios2_gen2_0_cpu_nios2_oci|nios_system_nios2_gen2_0_cpu_debug_slave_wrapper:the_nios_system_nios2_gen2_0_cpu_debug_slave_wrapper|nios_system_nios2_gen2_0_cpu_debug_slave_tck:the_nios_system_nios2_gen2_0_cpu_debug_slave_tck|*sr[34]}]
set_false_path -from [get_keepers {*nios_system_nios2_gen2_0_cpu:*|nios_system_nios2_gen2_0_cpu_nios2_oci:the_nios_system_nios2_gen2_0_cpu_nios2_oci|nios_system_nios2_gen2_0_cpu_nios2_ocimem:the_nios_system_nios2_gen2_0_cpu_nios2_ocimem|*MonDReg*}] -to [get_keepers {*nios_system_nios2_gen2_0_cpu:*|nios_system_nios2_gen2_0_cpu_nios2_oci:the_nios_system_nios2_gen2_0_cpu_nios2_oci|nios_system_nios2_gen2_0_cpu_debug_slave_wrapper:the_nios_system_nios2_gen2_0_cpu_debug_slave_wrapper|nios_system_nios2_gen2_0_cpu_debug_slave_tck:the_nios_system_nios2_gen2_0_cpu_debug_slave_tck|*sr*}]
set_false_path -from [get_keepers {*nios_system_nios2_gen2_0_cpu:*|nios_system_nios2_gen2_0_cpu_nios2_oci:the_nios_system_nios2_gen2_0_cpu_nios2_oci|nios_system_nios2_gen2_0_cpu_debug_slave_wrapper:the_nios_system_nios2_gen2_0_cpu_debug_slave_wrapper|nios_system_nios2_gen2_0_cpu_debug_slave_tck:the_nios_system_nios2_gen2_0_cpu_debug_slave_tck|*sr*}] -to [get_keepers {*nios_system_nios2_gen2_0_cpu:*|nios_system_nios2_gen2_0_cpu_nios2_oci:the_nios_system_nios2_gen2_0_cpu_nios2_oci|nios_system_nios2_gen2_0_cpu_debug_slave_wrapper:the_nios_system_nios2_gen2_0_cpu_debug_slave_wrapper|nios_system_nios2_gen2_0_cpu_debug_slave_sysclk:the_nios_system_nios2_gen2_0_cpu_debug_slave_sysclk|*jdo*}]
set_false_path -from [get_keepers {sld_hub:*|irf_reg*}] -to [get_keepers {*nios_system_nios2_gen2_0_cpu:*|nios_system_nios2_gen2_0_cpu_nios2_oci:the_nios_system_nios2_gen2_0_cpu_nios2_oci|nios_system_nios2_gen2_0_cpu_debug_slave_wrapper:the_nios_system_nios2_gen2_0_cpu_debug_slave_wrapper|nios_system_nios2_gen2_0_cpu_debug_slave_sysclk:the_nios_system_nios2_gen2_0_cpu_debug_slave_sysclk|ir*}]
set_false_path -from [get_keepers {sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1]}] -to [get_keepers {*nios_system_nios2_gen2_0_cpu:*|nios_system_nios2_gen2_0_cpu_nios2_oci:the_nios_system_nios2_gen2_0_cpu_nios2_oci|nios_system_nios2_gen2_0_cpu_nios2_oci_debug:the_nios_system_nios2_gen2_0_cpu_nios2_oci_debug|monitor_go}]
set_false_path -from [get_registers {*altera_avalon_st_clock_crosser:*|in_data_buffer*}] -to [get_registers {*altera_avalon_st_clock_crosser:*|out_data_buffer*}]
set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************
