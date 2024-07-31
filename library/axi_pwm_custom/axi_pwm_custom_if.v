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

// internal registers

  reg      [11:0]  data_channel_0_t = 12'b0;
  reg      [11:0]  data_channel_1_t = 12'b0;
  reg      [11:0]  data_channel_2_t = 12'b0;
  reg      [11:0]  data_channel_3_t = 12'b0;
  reg      [11:0]  data_channel_4_t = 12'b0;
  reg      [11:0]  data_channel_5_t = 12'b0;
  reg      [11:0]  count = 12'b0;
  reg      [11:0]  full_period = PULSE_PERIOD;
  reg              pwm_led_0_t = 1'b0;
  reg              pwm_led_1_t = 1'b0;
  reg              pwm_led_2_t = 1'b0;
  reg              pwm_led_3_t = 1'b0;
  reg              pwm_led_4_t = 1'b0;
  reg              pwm_led_5_t = 1'b0;

// internal wires

  wire             end_of_period;

  assign pwm_led_0 = pwm_led_0_t;
  assign pwm_led_1 = pwm_led_1_t;
  assign pwm_led_2 = pwm_led_2_t;
  assign pwm_led_3 = pwm_led_3_t;
  assign pwm_led_4 = pwm_led_4_t;
  assign pwm_led_5 = pwm_led_5_t;

// generate a signal named end_of_period which has '1' logic value at the end of the signal period

  assign end_of_period = (count == full_period) ? 1'b1 : 1'b0;

// Create a counter from 0 to PULSE_PERIOD

  always @(posedge pwm_clk) begin

    if (end_of_period || !rstn)
      count <= 1'b0;
    else
      count <= count + 1;
    
  end

// control the pwm signal value based on the input signal and counter value

  always @(posedge pwm_clk) begin

    if (count < data_channel_0)
      pwm_led_0_t <= 1'b1;
    else
      pwm_led_0_t <= 1'b0;
    if (count < data_channel_1)
      pwm_led_1_t <= 1'b1;
    else
      pwm_led_1_t <= 1'b0;
    if (count < data_channel_2)
      pwm_led_2_t <= 1'b1;
    else
      pwm_led_2_t <= 1'b0;
    if (count < data_channel_3)
      pwm_led_3_t <= 1'b1;
    else
      pwm_led_3_t <= 1'b0;
    if (count < data_channel_4)
      pwm_led_4_t <= 1'b1;
    else
      pwm_led_4_t <= 1'b0;
    if (count < data_channel_5)
      pwm_led_5_t <= 1'b1;
    else
      pwm_led_5_t <= 1'b0;

  end

// make sure that the new data is processed only after the END_OF_PERIOD

  always @(posedge pwm_clk) begin

    if (end_of_period || !rstn) begin
      data_channel_0_t <= data_channel_0;
      data_channel_1_t <= data_channel_1;
      data_channel_2_t <= data_channel_2;
      data_channel_3_t <= data_channel_3;
      data_channel_4_t <= data_channel_4;
      data_channel_5_t <= data_channel_5;
    end else begin
      data_channel_0_t <= data_channel_0_t;
      data_channel_1_t <= data_channel_1_t;
      data_channel_2_t <= data_channel_2_t;
      data_channel_3_t <= data_channel_3_t;
      data_channel_4_t <= data_channel_4_t;
      data_channel_5_t <= data_channel_5_t;
    end
    
  end

endmodule
