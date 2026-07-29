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

  /*here*/
reg[11:0] channel_0_value;
reg[11:0] channel_1_value;
reg[11:0] channel_2_value;
reg[11:0] channel_3_value;
reg[11:0] channel_4_value;
reg[11:0] channel_5_value;
reg[11:0] counter_value;
reg compare_channel_0;
reg compare_channel_1;
reg compare_channel_2;
reg compare_channel_3;
reg compare_channel_4;
reg compare_channel_5;

// internal wires
wire end_of_period;

// generate a signal named end_of_period which has '1' logic value at the end of the signal period
assign end_of_period = &(counter_value);

// Create a counter from 0 to PULSE_PERIOD
always @(posedge pwm_clk) begin
  if (~rstn) begin
    counter_value <= 12'b0;
  end else begin
    counter_value <= (counter_value < 12'Hfff) ? counter_value + 1 : 12'H000;
  end
end

// control the pwm signal value based on the input signal and counter value
always @(posedge pwm_clk) begin
  if(~rstn) begin
    compare_channel_0 <= 1;
    compare_channel_1 <= 1;
    compare_channel_2 <= 1;
    compare_channel_3 <= 1;
    compare_channel_4 <= 1;
    compare_channel_5 <= 1;
  end else begin
    compare_channel_0 <= (channel_0_value > counter_value) ? 1 : 0;
    compare_channel_1 <= (channel_1_value > counter_value) ? 1 : 0;
    compare_channel_2 <= (channel_2_value > counter_value) ? 1 : 0;
    compare_channel_3 <= (channel_3_value > counter_value) ? 1 : 0;
    compare_channel_4 <= (channel_4_value > counter_value) ? 1 : 0;
    compare_channel_5 <= (channel_5_value > counter_value) ? 1 : 0;
  end
end

// make sure that the new data is processed only after the END_OF_PERIOD
always @(posedge pwm_clk) begin
  if (end_of_period || ~rstn) begin
    channel_0_value <= data_channel_0;
    channel_1_value <= data_channel_1;
    channel_2_value <= data_channel_2;
    channel_3_value <= data_channel_3;
    channel_4_value <= data_channel_4;
    channel_5_value <= data_channel_5;
  end
end

// continous assigment of the correct PWM value for the LEDs
assign pwm_led_0 = compare_channel_0;
assign pwm_led_1 = compare_channel_1;
assign pwm_led_2 = compare_channel_2;
assign pwm_led_3 = compare_channel_3;
assign pwm_led_4 = compare_channel_4;
assign pwm_led_5 = compare_channel_5;

endmodule
