# ip

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_pwm_custom

create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name my_ila
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] [get_ips my_ila]
set_property -dict [list CONFIG.C_NUM_OF_PROBES {13}] [get_ips my_ila]
set_property -dict [list CONFIG.C_DATA_DEPTH {4096}] [get_ips my_ila]
set_property -dict [list CONFIG.C_TRIGIN_EN {false}] [get_ips my_ila]
set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] [get_ips my_ila]
set_property -dict [list CONFIG.C_PROBE1_WIDTH {12}] [get_ips my_ila]
set_property -dict [list CONFIG.C_PROBE2_WIDTH {12}] [get_ips my_ila]
set_property -dict [list CONFIG.C_PROBE3_WIDTH {12}] [get_ips my_ila]
set_property -dict [list CONFIG.C_PROBE4_WIDTH {12}] [get_ips my_ila]
set_property -dict [list CONFIG.C_PROBE5_WIDTH {12}] [get_ips my_ila]
set_property -dict [list CONFIG.C_PROBE6_WIDTH {12}] [get_ips my_ila]
set_property -dict [list CONFIG.C_PROBE7_WIDTH {1}] [get_ips my_ila]
set_property -dict [list CONFIG.C_PROBE8_WIDTH {1}] [get_ips my_ila]
set_property -dict [list CONFIG.C_PROBE9_WIDTH {1}] [get_ips my_ila]
set_property -dict [list CONFIG.C_PROBE10_WIDTH {1}] [get_ips my_ila]
set_property -dict [list CONFIG.C_PROBE11_WIDTH {1}] [get_ips my_ila]
set_property -dict [list CONFIG.C_PROBE12_WIDTH {1}] [get_ips my_ila]
generate_target {all} [get_files axi_pwm_custom.srcs/sources_1/ip/my_ila/my_ila.xci]

adi_ip_files axi_pwm_custom [list \
  "$ad_hdl_dir/library/common/up_axi.v" \
  "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
  "$ad_hdl_dir/library/common/up_xfer_status.v" \
  "$ad_hdl_dir/library/common/up_adc_channel.v" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
  "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
  "axi_pwm_custom_if.v"\
  "axi_pwm_custom.v"]

adi_ip_properties axi_pwm_custom

set cc [ipx::current_core]

set_property display_name "ADI PWM CUSTOM" $cc
set_property description "Custom PWM generator" $cc

ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces s_axi_aclk -of_objects [ipx::current_core]]

ipx::create_xgui_files $cc
ipx::save_core $cc