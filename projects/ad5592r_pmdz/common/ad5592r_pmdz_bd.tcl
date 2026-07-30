# #############################################################################
# Block Design Script — ad5592r_pmdz
#
# This Tcl script builds the block design for the ad5592r_pmdz project.
# It runs inside Vivado and uses ADI helper commands defined in:
#   projects/scripts/adi_board.tcl
#
# Useful commands reference:
#
#   create_bd_port -dir <Direction> [-from <N> -to <M>] <port_name>
#       Creates an external port on the block design.
#       -dir   : port direction — I (input), O (output), IO (bidirectional)
#       -from/-to : optional, creates a bus port of width [N:M]
#                   e.g. -from 7 -to 0 for an 8-bit bus
#       <port_name> : name of the port (will appear on the top-level wrapper)
#
#   ad_ip_instance <ip_name> <instance_name> [<param_list>]
#       Instantiates an IP core in the block design.
#       <ip_name>       : the IP type to instantiate (e.g. axi_dmac)
#       <instance_name> : the name you give this instance in the design
#       <param_list>    : optional, key-value list to configure the IP
#
#   ad_connect <source> <destination>
#       Connects two block design objects: pins, ports, or interfaces.
#       <source>      : source pin/port (e.g. my_ip/pwm_out or a top-level port)
#       <destination> : destination pin/port
#       Also handles GND/VCC constants automatically.
#
#   ad_cpu_interconnect <base_address> <instance_name>
#       Connects an IP's AXI-Lite slave interface to the CPU bus and assigns
#       it the given base address in the memory map.
#       <base_address>  : hex address (e.g. 0x43C00000)
#       <instance_name> : the IP instance to connect
#
# #############################################################################

# 1. Create output ports for the PWM-driven RGB LEDs
#    These ports will be mapped to FPGA pins in the constraints file (.xdc).

  create_bd_port -dir O pwm_led1_b
  create_bd_port -dir O pwm_led1_g
  create_bd_port -dir O pwm_led1_r
  create_bd_port -dir O pwm_led2_b
  create_bd_port -dir O pwm_led2_g
  create_bd_port -dir O pwm_led2_r

# 2. Instantiate the axi_pwm_custom IP core.
#    This creates a block named "axi_pwm_custom" in the design using
#    the axi_pwm_custom IP (defined in library/axi_pwm_custom).

  ad_ip_instance axi_pwm_custom my_own_private_pwm_ip

# 3. Connect each top-level port to the corresponding output pin
#    of the axi_pwm_custom IP.

  ad_connect my_own_private_pwm_ip/pwm_led1_b pwm_led1_b
  ad_connect my_own_private_pwm_ip/pwm_led1_g pwm_led1_g
  ad_connect my_own_private_pwm_ip/pwm_led1_r pwm_led1_r
  ad_connect my_own_private_pwm_ip/pwm_led2_b pwm_led2_b
  ad_connect my_own_private_pwm_ip/pwm_led2_g pwm_led2_g
  ad_connect my_own_private_pwm_ip/pwm_led2_r pwm_led2_r

# 4. Connect the axi_pwm_custom IP to the CPU's AXI bus at address 0x44A00000.
#    This lets software read/write the IP's registers from the PS (processing system).

  ad_cpu_interconnect 0x44A00000 my_own_private_pwm_ip
