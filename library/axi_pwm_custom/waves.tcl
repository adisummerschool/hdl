add_wave_divider "=== Testbench ==="
add_wave /axi_pwm_custom_if_tb/pwm_clk
add_wave /axi_pwm_custom_if_tb/resetn_in
add_wave /axi_pwm_custom_if_tb/data_channel_0
add_wave /axi_pwm_custom_if_tb/data_channel_1
add_wave /axi_pwm_custom_if_tb/data_channel_2
add_wave /axi_pwm_custom_if_tb/data_channel_3
add_wave /axi_pwm_custom_if_tb/data_channel_4
add_wave /axi_pwm_custom_if_tb/data_channel_5
add_wave /axi_pwm_custom_if_tb/pulse_period_cnt
add_wave /axi_pwm_custom_if_tb/end_of_period
add_wave /axi_pwm_custom_if_tb/pre_trn_state
add_wave /axi_pwm_custom_if_tb/pwm_led_0
add_wave /axi_pwm_custom_if_tb/pwm_led_1
add_wave /axi_pwm_custom_if_tb/pwm_led_2
add_wave /axi_pwm_custom_if_tb/pwm_led_3
add_wave /axi_pwm_custom_if_tb/pwm_led_4
add_wave /axi_pwm_custom_if_tb/pwm_led_5
add_wave_divider "=== DUT Internals ==="
add_wave -recursive /axi_pwm_custom_if_tb/axi_pwm_custom_if_dut/*
