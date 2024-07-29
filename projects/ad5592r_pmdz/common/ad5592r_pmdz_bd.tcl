# 1. create ports: pwm_led_0_r, pwm_led_0_g, pwm_led_0_b, pwm_led_1_r, pwm_led_1_g, pwm_led_1_b ports
    # command example: create_bd_port -dir O example led

  #here
  create_bd_port -dir O pwm_led_0_r 
  #here
  create_bd_port -dir O pwm_led_0_g 
  #here
  create_bd_port -dir O pwm_led_0_b 

  #here
  create_bd_port -dir O pwm_led_1_r 
  #here
  create_bd_port -dir O pwm_led_1_g 
  #here
  create_bd_port -dir O pwm_led_1_b 

# 2. add axi_pwm_custom IP using ad_ip_instance command

  #here
  ad_ip_instance axi_pwm_custom axi_pwm_custom_i

# 3. connect the axi_pwm_custom IP to the block design ports using ad_connect command

  #here
  ad_connect pwm_led_0_r axi_pwm_custom_i/pwm_led_0
  #here
  ad_connect pwm_led_0_g axi_pwm_custom_i/pwm_led_1
  #here
  ad_connect pwm_led_0_b axi_pwm_custom_i/pwm_led_2
  #here
  ad_connect pwm_led_1_r axi_pwm_custom_i/pwm_led_3
  #here
  ad_connect pwm_led_1_g axi_pwm_custom_i/pwm_led_4
  #here
  ad_connect pwm_led_1_b axi_pwm_custom_i/pwm_led_5

# 4. connect the axi_pwm_custom IP to the CPU using ad_cpu_interconnect at 0x44a00000
  ad_cpu_interconnect 0x44a00000 axi_pwm_custom_i
  #here
