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

  localparam PULSE_PERIOD = 4095;

// internal registers - here

  reg [11:0] pwm_counter = 0;
  reg [11:0] pwm_value_0 = 0;
  reg [11:0] pwm_value_1 = 0;
  reg [11:0] pwm_value_2 = 0;
  reg [11:0] pwm_value_3 = 0;
  reg [11:0] pwm_value_4 = 0;
  reg [11:0] pwm_value_5 = 0;

// internal wires -here

  wire end_of_period;

// generate a signal named end_of_period which has '1' logic value at the end of the signal period - here

  assign end_of_period = (pwm_counter == PULSE_PERIOD) ? 1'b1 : 1'b0;

// Create a counter from 0 to PULSE_PERIOD - here

   always @(posedge pwm_clk or negedge rstn) begin
    if (!rstn)
      pwm_counter <= 0;
    else if (end_of_period)
      pwm_counter <= 0;
    else
      pwm_counter <= pwm_counter + 1'b1;
  end

// control the pwm signal value based on the input signal and counter value - here

  always @(posedge pwm_clk or negedge rstn) begin
    if (!rstn) begin
      pwm_value_0 <= 0;
      pwm_value_1 <= 0;
      pwm_value_2 <= 0;
      pwm_value_3 <= 0;
      pwm_value_4 <= 0;
      pwm_value_5 <= 0;

// make sure that the new data is processed only after the END_OF_PERIOD -here

    end else if (end_of_period) begin
      pwm_value_0 <= data_channel_0;
      pwm_value_1 <= data_channel_1;
      pwm_value_2 <= data_channel_2;
      pwm_value_3 <= data_channel_3;
      pwm_value_4 <= data_channel_4;
      pwm_value_5 <= data_channel_5;
    end
  end

// continous assigment of the correct PWM value for the LEDs - here

  assign pwm_led_0 = (pwm_counter < pwm_value_0) ? 1'b1 : 1'b0;;
  assign pwm_led_1 = (pwm_counter < pwm_value_1) ? 1'b1 : 1'b0;
  assign pwm_led_2 = (pwm_counter < pwm_value_2) ? 1'b1 : 1'b0;
  assign pwm_led_3 = (pwm_counter < pwm_value_3) ? 1'b1 : 1'b0;
  assign pwm_led_4 = (pwm_counter < pwm_value_4) ? 1'b1 : 1'b0;
  assign pwm_led_5 = (pwm_counter < pwm_value_5) ? 1'b1 : 1'b0;

endmodule
