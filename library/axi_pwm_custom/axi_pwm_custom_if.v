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
  reg [11:0] triangle;

  reg [11:0] channel_0_valid;
  reg [11:0] channel_1_valid;
  reg [11:0] channel_2_valid;
  reg [11:0] channel_3_valid;  
  reg [11:0] channel_4_valid;
  reg [11:0] channel_5_valid;   

  reg reg_pwm_led_0;
  reg reg_pwm_led_1;
  reg reg_pwm_led_2;
  reg reg_pwm_led_3;
  reg reg_pwm_led_4;
  reg reg_pwm_led_5;

  reg end_of_period;

  /*here*/

// internal wires
always @(posedge pwm_clk) begin
  if (end_of_period || !rstn) begin
        channel_0_valid <= data_channel_0;
        channel_1_valid <= data_channel_1;
        channel_2_valid <= data_channel_2;
        channel_3_valid <= data_channel_3;
        channel_4_valid <= data_channel_4;
        channel_5_valid <= data_channel_5;
    end
end
  /*here*/

// generate a signal named end_of_period which has '1' logic value at the end of the signal period

  /*here*/
  always @(posedge pwm_clk) begin
   if(!rstn) begin
   end_of_period <= 1'b0;
   end
    else if(triangle == PULSE_PERIOD) begin
   end_of_period <= 1'b1;
    end
    else begin
   end_of_period <= 1'b0;
    end
  end
// Create a counter from 0 to PULSE_PERIOD

  /*here*/
  always @(posedge pwm_clk) begin
    if(!rstn) begin
      triangle <= 12'h000;
    end
    else if(triangle < PULSE_PERIOD) begin
      triangle <= triangle + 12'h001;
    end
    else begin
      triangle <= 12'h000;
    end
  end 

// control the pwm signal value based on the input signal and counter value

  /*here*/

// make sure that the new data is processed only after the END_OF_PERIOD

  /*here*/

// continous assigment of the correct PWM value for the LEDs
 always @(posedge pwm_clk) begin
  
  if(triangle < channel_0_valid || !rstn) begin
    reg_pwm_led_0 <= 1'b1;
  end
  else begin
    reg_pwm_led_0 <= 1'b0;
  end

    if(triangle < channel_1_valid || !rstn) begin
    reg_pwm_led_1 <= 1'b1;
    
  end
  else begin
    reg_pwm_led_1 <= 1'b0;
  end
    if(triangle < channel_2_valid || !rstn) begin
    reg_pwm_led_2 <= 1'b1;
  end
  else begin
    reg_pwm_led_2 <= 1'b0;
  end  
  if(triangle < channel_3_valid || !rstn) begin
    reg_pwm_led_3 <= 1'b1;
  end
  else begin
    reg_pwm_led_3 <= 1'b0;
  end  
  if(triangle < channel_4_valid || !rstn) begin
    reg_pwm_led_4 <= 1'b1;
  end
  else begin
    reg_pwm_led_4 <= 1'b0;
  end
    if(triangle < channel_5_valid || !rstn) begin
    reg_pwm_led_5 <= 1'b1;
  end
  else begin
    reg_pwm_led_5 <= 1'b0;
  end
 end
 /*here*/
  assign pwm_led_0 = reg_pwm_led_0;
  assign pwm_led_1 = reg_pwm_led_1;
  assign pwm_led_2 = reg_pwm_led_2;
  assign pwm_led_3 = reg_pwm_led_3;
  assign pwm_led_4 = reg_pwm_led_4;
  assign pwm_led_5 = reg_pwm_led_5;

endmodule
