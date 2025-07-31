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

  reg led0;
  reg led1;
  reg led2;
  reg led3;
  reg led4;
  reg led5;
  reg [11:0] cnt =12'd0;

// internal wires

  reg [11:0] val0;
  reg [11:0] val1;
  reg [11:0] val2;
  reg [11:0] val3;
  reg [11:0] val4;
  reg [11:0] val5;
  wire end_of_period;

// generate a signal named end_of_period which has '1' logic value at the end of the signal period

  assign end_of_period = (cnt == PULSE_PERIOD);

// Create a counter from 0 to PULSE_PERIOD

  always @(posedge pwm_clk or negedge rstn) begin
    if (!rstn || end_of_period)
      cnt <= 12'd0;
      
    else
      cnt <= cnt + 12'd1;
  end

// control the pwm signal value based on the input signal and counter value

  // assign pwm_led_0 = (data_channel_0 > cnt);
  // assign pwm_led_1 = (data_channel_1 > cnt);
  // assign pwm_led_2 = (data_channel_2 > cnt);
  // assign pwm_led_3 = (data_channel_3 > cnt);
  // assign pwm_led_4 = (data_channel_4 > cnt);
  // assign pwm_led_5 = (data_channel_5 > cnt);

  always @(posedge pwm_clk or negedge rstn) begin
    if(!rstn) begin
      led0 <= 1'b0;
      led1 <= 1'b0;
      led2 <= 1'b0;
      led3 <= 1'b0;
      led4 <= 1'b0;
      led5 <= 1'b0;
    end
    else begin
      if(val0 >= cnt)
        led0 <= 1'b1;
      else
        led0 <= 1'b0; 
      if(val1 >= cnt)
        led1 <= 1'b1;
      else
        led1 <= 1'b0; 
      if(val2 >= cnt)
        led2 <= 1'b1;
      else
        led2 <= 1'b0; 
      if(val3 >= cnt)
        led3 <= 1'b1;
      else
        led3 <= 1'b0; 
      if(val4 >= cnt)
        led4 <= 1'b1;
      else
        led4 <= 1'b0; 
      if(val5 >= cnt)
        led5 <= 1'b1;
      else
        led5 <= 1'b0; 
    end
  end

// make sure that the new data is processed only after the END_OF_PERIOD

  always @(posedge pwm_clk ) begin
   
   if(end_of_period)begin
      val0 <= data_channel_0;
      val1 <= data_channel_1;
      val2 <= data_channel_2;
      val3 <= data_channel_3;
      val4 <= data_channel_4;
      val5 <= data_channel_5;
    end 
    else begin
       val0 <= val0;
      val1 <= val1;
      val2 <= val2;
      val3 <= val3;
      val4 <= val4;
      val5 <= val5;
    end

  end

// continous assigment of the correct PWM value for the LEDs

  assign pwm_led_0 = led0;
  assign pwm_led_1 = led1;
  assign pwm_led_2 = led2;
  assign pwm_led_3 = led3;
  assign pwm_led_4 = led4;
  assign pwm_led_5 = led5;

endmodule
