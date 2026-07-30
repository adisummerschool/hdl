# 1. Update the signal names for both JA and JB PMOD connectors

## Pmod Header JA - ADC PMOD CONNECTOR

set_property -dict { PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 } [get_ports {adc_spi_csn}];  # JA pin 1: CS
set_property -dict { PACKAGE_PIN Y19 IOSTANDARD LVCMOS33 } [get_ports {adc_spi_mosi}]; # JA pin 2: MOSI
set_property -dict { PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 } [get_ports {adc_spi_miso}]; # JA pin 3: MISO
set_property -dict { PACKAGE_PIN Y17 IOSTANDARD LVCMOS33 } [get_ports {adc_spi_clk}];  # JA pin 4: SCLK

#set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports {...}];
#set_property -dict { PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports {...}];
#set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports {...}];
#set_property -dict { PACKAGE_PIN W19 IOSTANDARD LVCMOS33 } [get_ports {...}];


## Pmod Header JB - SNIFFING PMOD CONNECTOR

set_property -dict { PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports {sniff_spi_csn}];  # JB pin 1: CS
set_property -dict { PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 } [get_ports {sniff_spi_mosi}]; # JB pin 2: MOSI
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports {sniff_spi_miso}]; # JB pin 3: MISO
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports {sniff_spi_clk}];  # JB pin 4: SCLK




## GPIO - RGB LEDs

set_property -dict { PACKAGE_PIN L15 IOSTANDARD LVCMOS33 } [get_ports {led[0]}]; # LED0_B
set_property -dict { PACKAGE_PIN N15 IOSTANDARD LVCMOS33 } [get_ports {led[1]}]; # LED0_R
set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports {led[2]}]; # LED0_G

set_property -dict { PACKAGE_PIN G14 IOSTANDARD LVCMOS33 } [get_ports {led[3]}]; # LED1_B
set_property -dict { PACKAGE_PIN M15 IOSTANDARD LVCMOS33 } [get_ports {led[4]}]; # LED1_R
set_property -dict { PACKAGE_PIN L14 IOSTANDARD LVCMOS33 } [get_ports {led[5]}]; # LED1_G