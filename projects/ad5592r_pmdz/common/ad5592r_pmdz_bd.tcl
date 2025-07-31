# 1. create ports: pwm_led_0_r, pwm_led_0_g, pwm_led_0_b, pwm_led_1_r, pwm_led_1_g, pwm_led_1_b ports
    # command example: create_bd_port -dir O example led; I - input

  create_bd_port -dir O pwm_led_0_r
  create_bd_port -dir O pwm_led_0_g
  create_bd_port -dir O pwm_led_0_b

  create_bd_port -dir O pwm_led_1_r
  create_bd_port -dir O pwm_led_1_g
  create_bd_port -dir O pwm_led_1_b

# 2. add axi_pwm_custom IP using ad_ip_instance command

  ad_ip_instance axi_pwm_custom axi_pwm_custom_led 

# 3. connect the axi_pwm_custom IP to the block design ports using ad_connect command

  ad_connect axi_pwm_custom_led/pwm_led_0 pwm_led_0_r
  ad_connect axi_pwm_custom_led/pwm_led_1 pwm_led_0_g
  ad_connect axi_pwm_custom_led/pwm_led_2 pwm_led_0_b

  ad_connect axi_pwm_custom_led/pwm_led_3 pwm_led_1_r
  ad_connect axi_pwm_custom_led/pwm_led_4 pwm_led_1_g
  ad_connect axi_pwm_custom_led/pwm_led_5 pwm_led_1_b

# 4. connect the axi_pwm_custom IP to the CPU using ad_cpu_interconnect at 0x44a00000

  ad_cpu_interconnect 0x44a00000 axi_pwm_custom_led
