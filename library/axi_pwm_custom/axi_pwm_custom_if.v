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
  output   reg     pwm_led_0,
  output   reg     pwm_led_1,
  output   reg     pwm_led_2,
  output   reg     pwm_led_3,
  output   reg     pwm_led_4,
  output   reg     pwm_led_5
);

  localparam PULSE_PERIOD = 4095;

// internal registers

  /*here*/
  reg      [11:0] data_channel_0_reg;
  reg      [11:0] data_channel_1_reg;
  reg      [11:0] data_channel_2_reg;
  reg      [11:0] data_channel_3_reg;
  reg      [11:0] data_channel_4_reg;
  reg      [11:0] data_channel_5_reg;

  reg      [11:0] counter_reg;

  reg             end_of_period;

// internal wires


// generate a signal named end_of_period which has '1' logic value at the end of the signal period
// Create a counter from 0 to PULSE_PERIOD

  always@(posedge pwm_clk) begin

    if (rstn == 0) begin
      counter_reg <= 3'h000;
      end_of_period <= 0;
    end

    else begin
      if (counter_reg < PULSE_PERIOD) begin
        counter_reg <= counter_reg + 1;
        end_of_period <= 0;
      end
      else if (counter_reg == PULSE_PERIOD) begin
        counter_reg <= 3'h000;
        end_of_period <= 1; 
      end
    end

  end

// control the pwm signal value based on the input signal and counter value
  always@(posedge pwm_clk) begin
    if (rstn == 0) begin
      pwm_led_0 <= 1;
      pwm_led_1 <= 1;
      pwm_led_2 <= 1;
      pwm_led_3 <= 1;
      pwm_led_4 <= 1;
      pwm_led_5 <= 1;
    end
    else begin 
    // channel 0
    if (data_channel_0_reg > counter_reg) begin
      pwm_led_0 <= 1;
    end else begin 
      pwm_led_0 <= 0;
    end

    // channel 1
    if (data_channel_1_reg > counter_reg) begin
      pwm_led_1 <= 1;
    end else begin
      pwm_led_1 <= 0;
    end

    // channel 2
    if (data_channel_2_reg > counter_reg) begin
      pwm_led_2 <= 1;
    end else begin 
      pwm_led_2 <= 0;
    end

    // channel 3
    if (data_channel_3_reg > counter_reg) begin
      pwm_led_3 <= 1;
    end else begin
      pwm_led_3 <= 0;
    end

    // channel 4
    if (data_channel_4_reg > counter_reg) begin
      pwm_led_4 <= 1;
    end else begin 
      pwm_led_4 <= 0;
    end

    // channel 5
    if (data_channel_5_reg > counter_reg) begin
      pwm_led_5 <= 1;
    end else begin
      pwm_led_5 <= 0;
    end
  end 
  end

// make sure that the new data is processed only after the END_OF_PERIOD

  always@(posedge pwm_clk) begin
    if (rstn == 0 || end_of_period == 1) begin 
      data_channel_0_reg <= data_channel_0;
      data_channel_1_reg <= data_channel_1;
      data_channel_2_reg <= data_channel_2;
      data_channel_3_reg <= data_channel_3;
      data_channel_4_reg <= data_channel_4;
      data_channel_5_reg <= data_channel_5;
    end
  end

// continous assigment of the correct PWM value for the LEDs

 /*here*/

endmodule
