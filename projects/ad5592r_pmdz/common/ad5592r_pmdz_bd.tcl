# 1. create ports: pwm_led_0_r, pwm_led_0_g, pwm_led_0_b, pwm_led_1_r, pwm_led_1_g, pwm_led_1_b ports
    # command example: create_bd_port -dir O example led

  #here
  create_bd_port -dir O pwm_led0
  #here
  create_bd_port -dir O pwm_led1
  #here
  create_bd_port -dir O pwm_led2

  #here
  create_bd_port -dir O pwm_led3
  #here
  create_bd_port -dir O pwm_led4
  #here
  create_bd_port -dir O pwm_led5

# 2. add axi_pwm_custom IP using ad_ip_instance command

  #here
  ad_ip_instance axi_pwm_custom axi_pwm_custom_led

# 3. connect the axi_pwm_custom IP to the block design ports using ad_connect command

  #here
  ad_connect axi_pwm_custom_led/pwm_led0 pwm_led_0_r
  #here
  ad_connect axi_pwm_custom_led/pwm_led1 pwm_led_0_g
  #here
  ad_connect axi_pwm_custom_led/pwm_led2 pwm_led_0_b

  #here
  ad_connect axi_pwm_custom_led/pwm_led3 pwm_led_1_r
  #here
  ad_connect axi_pwm_custom_led/pwm_led4 pwm_led_1_g
  #here
  ad_connect axi_pwm_custom_led/pwm_led5 pwm_led_1_b

# 4. connect the axi_pwm_custom IP to the CPU using ad_cpu_interconnect at 0x44a00000

  #here
  ad_cpu_interconnect 0x44a00000 axi_pwm_custom_led