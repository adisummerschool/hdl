# ip

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create axi_pwm_custom
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