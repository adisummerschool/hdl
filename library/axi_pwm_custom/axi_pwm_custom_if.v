// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
// This is the LVDS/DDR interface

`timescale 1ns/100ps

module axi_pwm_custom_if ( 

  input            pwm_clk,
  input            rstn,
  input    [11:0]  data_channel_0,
  input    [11:0]  data_channel_1,
  input    [11:0]  data_channel_2,
  input    [11:0]  data_channel_3,
  input    [11:0]  data_channel_4,
  input    [11:0]  data_channel_5,
  output           pwm_led_0,
  output           pwm_led_1,
  output           pwm_led_2,
  output           pwm_led_3,
  output           pwm_led_4,
  output           pwm_led_5
);

  localparam PULSE_PERIOD = 12'd4095;

// internal registers

  reg [11:0] count;

  reg [11:0] in_reg_channel_0;
  reg [11:0] in_reg_channel_1;
  reg [11:0] in_reg_channel_2;
  reg [11:0] in_reg_channel_3;
  reg [11:0] in_reg_channel_4;
  reg [11:0] in_reg_channel_5;

  reg [11:0] out_reg_channel_0;
  reg [11:0] out_reg_channel_1;
  reg [11:0] out_reg_channel_2;
  reg [11:0] out_reg_channel_3;
  reg [11:0] out_reg_channel_4;
  reg [11:0] out_reg_channel_5;

  reg led_0;
  reg led_1;
  reg led_2;
  reg led_3;
  reg led_4;
  reg led_5;

  reg end_of_period;

// internal wires

  /*here*/

// generate a signal named end_of_period which has '1' logic value at the end of the signal period

// Create a counter from 0 to PULSE_PERIOD

  always @(posedge pwm_clk) begin
    if (rstn == 0) begin
      count = 12'd0;
      end_of_period = 0;
      
      led_0 = 0;
      led_1 = 0;
      led_2 = 0;
      led_3 = 0;
      led_4 = 0;
      led_5 = 0;

      in_reg_channel_0 = 0;
      in_reg_channel_1 = 0;
      in_reg_channel_2 = 0;
      in_reg_channel_3 = 0;
      in_reg_channel_4 = 0;
      in_reg_channel_5 = 0;

      out_reg_channel_0 = 0;
      out_reg_channel_1 = 0;
      out_reg_channel_2 = 0;
      out_reg_channel_3 = 0;
      out_reg_channel_4 = 0;
      out_reg_channel_5 = 0;
    end
    else begin
      if (count < PULSE_PERIOD) begin
        count = count + 1;
        end_of_period = 0;
      end
      else begin
        count = 12'd0;
        end_of_period = 1;
      end
      
      if (end_of_period == 1) begin
        in_reg_channel_0 = data_channel_0;
        in_reg_channel_1 = data_channel_1;
        in_reg_channel_2 = data_channel_2;
        in_reg_channel_3 = data_channel_3;
        in_reg_channel_4 = data_channel_4;
        in_reg_channel_5 = data_channel_5;
      end
      
      out_reg_channel_0 = in_reg_channel_0;
      out_reg_channel_1 = in_reg_channel_1;
      out_reg_channel_2 = in_reg_channel_2;
      out_reg_channel_3 = in_reg_channel_3;
      out_reg_channel_4 = in_reg_channel_4;
      out_reg_channel_5 = in_reg_channel_5;

      if (out_reg_channel_0 > count)
        led_0 = 1;
      else
        led_0 = 0;

      if (out_reg_channel_1 > count)
        led_1 = 1;
      else
        led_1 = 0;

      if (out_reg_channel_2 > count)
        led_2 = 1;
      else
        led_2 = 0;

      if (out_reg_channel_3 > count)
        led_3 = 1;
      else
        led_3 = 0;

      if (out_reg_channel_4 > count)
        led_4 = 1;
      else
        led_4 = 0;

      if (out_reg_channel_5 > count)
        led_5 = 1;
      else
        led_5 = 0;

    end
  end

// control the pwm signal value based on the input signal and counter value

  /*here*/

// make sure that the new data is processed only after the END_OF_PERIOD

  /*here*/

// continous assigment of the correct PWM value for the LEDs

 assign pwm_led_0 = led_0;
 assign pwm_led_1 = led_1;
 assign pwm_led_2 = led_2;
 assign pwm_led_3 = led_3;
 assign pwm_led_4 = led_4;
 assign pwm_led_5 = led_5;

endmodule
