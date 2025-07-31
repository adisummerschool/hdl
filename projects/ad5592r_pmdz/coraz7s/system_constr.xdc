# 1. Update the signals names for both JA and JB PMOD connectors

##Pmod Header JA   ADC PMOD CONNECTOR

set_property -dict { PACKAGE_PIN Y18  IOSTANDARD LVCMOS33 } [get_ports { cs }]; #IO_L17P_T2_34 Sch=ja_p[1]   			 
set_property -dict { PACKAGE_PIN Y19  IOSTANDARD LVCMOS33 } [get_ports { mosi}]; #IO_L17N_T2_34 Sch=ja_n[1]		     
set_property -dict { PACKAGE_PIN Y16  IOSTANDARD LVCMOS33 } [get_ports { miso }]; #IO_L7P_T1_34 Sch=ja_p[2]              
set_property -dict { PACKAGE_PIN Y17  IOSTANDARD LVCMOS33 } [get_ports { sclk }]; #IO_L7N_T1_34 Sch=ja_n[2]              
# set_property -dict { PACKAGE_PIN U18  IOSTANDARD LVCMOS33 } [get_ports { /*here*/ }]; #IO_L12P_T1_MRCC_34 Sch=ja_p[3]              
# set_property -dict { PACKAGE_PIN U19  IOSTANDARD LVCMOS33 } [get_ports { /*here*/ }]; #IO_L12N_T1_MRCC_34 Sch=ja_n[3]              
# set_property -dict { PACKAGE_PIN W18  IOSTANDARD LVCMOS33 } [get_ports { /*here*/ }]; #IO_L22P_T3_34 Sch=ja_p[4]              
# set_property -dict { PACKAGE_PIN W19  IOSTANDARD LVCMOS33 } [get_ports { /*here*/ }]; #IO_L22N_T3_34 Sch=ja_n[4]    

##Pmod Header JB   SNIFFING PMOD CONNECTOR

set_property -dict { PACKAGE_PIN W14  IOSTANDARD LVCMOS33  } [get_ports { scopy_cs }]; #IO_L8P_T1_34 Sch=jb_p[1]                  
set_property -dict { PACKAGE_PIN Y14  IOSTANDARD LVCMOS33  } [get_ports { scopy_mosi }]; #IO_L8N_T1_34 Sch=jb_n[1]				 
set_property -dict { PACKAGE_PIN T11  IOSTANDARD LVCMOS33  } [get_ports { scopy_miso }]; #IO_L1P_T0_34 Sch=jb_p[2]                  
set_property -dict { PACKAGE_PIN T10  IOSTANDARD LVCMOS33  } [get_ports { scopy_sclk }]; #IO_L1N_T0_34 Sch=jb_n[2]             
# set_property -dict { PACKAGE_PIN V16  IOSTANDARD LVCMOS33  } [get_ports { /*here*/ }]; #IO_L18P_T2_34 ISch=sclkjb_p[3]            
# set_property -dict { PACKAGE_PIN W16  IOSTANDARD LVCMOS33  } [get_ports { /*here*/ }]; #IO_L18N_T2_34 Sch=jb_n[3]            
# set_property -dict { PACKAGE_PIN V12  IOSTANDARD LVCMOS33  } [get_ports { /*here*/ }]; #IO_L4P_T0_34 Sch=jb_p[4]             
# set_property -dict { PACKAGE_PIN W13  IOSTANDARD LVCMOS33  } [get_ports { /*here*/ }]; #IO_L4N_T0_34 Sch=jb_n[4]         
