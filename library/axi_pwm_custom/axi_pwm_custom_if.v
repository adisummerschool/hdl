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
  reg end_of_period;
  reg [11:0] channel_0;
  reg [11:0] channel_1;
  reg [11:0] channel_2;
  reg [11:0] channel_3;
  reg [11:0] channel_4;
  reg [11:0] channel_5;
  reg [11:0] counter;
  reg comp0;
  reg comp1;
  reg comp2;
  reg comp3;
  reg comp4;
  reg comp5;

  

// internal wires
  
  ///

// generate a signal named end_of_period which has '1' logic value at the end of the signal period

always@(posedge pwm_clk) begin   ///////////

  if (counter == 12'hFFF) begin
  end_of_period <= 1;
  end
  else begin
  end_of_period <= 0;
  end

// Create a counter from 0 to PULSE_PERIOD

  if(~rstn) begin
    counter <= 1'b0;
    comp0 <= 1;
    comp1 <= 1;
    comp2 <= 1;
    comp3 <= 1;
    comp4 <= 1;
    comp5 <= 1;
  end 
  else begin
    counter <= (counter < PULSE_PERIOD) ? counter + 1'b1 : 12'b0;
  end
  
// control the pwm signal value based on the input signal and counter value

  if (rstn) begin
  comp0 <= (channel_0 > counter) ? 1'b1 : 1'b0;
  comp1 <= (channel_1 > counter) ? 1'b1 : 1'b0;
  comp2 <= (channel_2 > counter) ? 1'b1 : 1'b0;
  comp3 <= (channel_3 > counter) ? 1'b1 : 1'b0;
  comp4 <= (channel_4 > counter) ? 1'b1 : 1'b0;
  comp5 <= (channel_5 > counter) ? 1'b1 : 1'b0;
  end

end  // end always posedge clk   ///////////////

// make sure that the new data is processed only after the END_OF_PERIOD

  always@(posedge pwm_clk) begin
    if(end_of_period == 1 || ~rstn) begin 
      channel_0 <= data_channel_0;
      channel_1 <= data_channel_1;
      channel_2 <= data_channel_2;
      channel_3 <= data_channel_3;
      channel_4 <= data_channel_4;
      channel_5 <= data_channel_5;
    end
  end

// continous assigment of the correct PWM value for the LEDs

assign pwm_led_0 = comp0;
assign pwm_led_1 = comp1;
assign pwm_led_2 = comp2;
assign pwm_led_3 = comp3;
assign pwm_led_4 = comp4;
assign pwm_led_5 = comp5;

endmodule
