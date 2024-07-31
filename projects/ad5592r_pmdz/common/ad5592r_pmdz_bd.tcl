# 1. create ports: pwm_led_0_r, pwm_led_0_g, pwm_led_0_b, pwm_led_1_r, pwm_led_1_g, pwm_led_1_b ports
    # command example: create_bd_port -dir O example led

  create_bd_port -dir O pwm_led_0_r
  create_bd_port -dir O pwm_led_0_g
  create_bd_port -dir O pwm_led_0_b

  create_bd_port -dir O pwm_led_1_r
  create_bd_port -dir O pwm_led_1_g
  create_bd_port -dir O pwm_led_1_b

# 2. add axi_pwm_custom IP using ad_ip_instance command

  ad_ip_instance axi_pwm_custom axi_pwm_custom_xcr

# 3. connect the axi_pwm_custom IP to the block design ports using ad_connect command

  ad_connect pwm_led_0_r axi_pwm_custom_xcr/pwm_led_0
  ad_connect pwm_led_0_g axi_pwm_custom_xcr/pwm_led_1
  ad_connect pwm_led_0_b axi_pwm_custom_xcr/pwm_led_2

  ad_connect pwm_led_1_r axi_pwm_custom_xcr/pwm_led_3
  ad_connect pwm_led_1_g axi_pwm_custom_xcr/pwm_led_4
  ad_connect pwm_led_1_b axi_pwm_custom_xcr/pwm_led_5

# 4. connect the axi_pwm_custom IP to the CPU using ad_cpu_interconnect at 0x44a00000

  ad_cpu_interconnect 0x44a00000 axi_pwm_custom_xcr
