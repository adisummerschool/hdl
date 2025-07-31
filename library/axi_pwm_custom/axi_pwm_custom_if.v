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
  reg [11:0] counter_out = 12'd0;

  reg [11:0]  new_data_0 = 12'd0;
  reg [11:0]  new_data_1 = 12'd0;
  reg [11:0]  new_data_2 = 12'd0;
  reg [11:0]  new_data_3 = 12'd0;
  reg [11:0]  new_data_4 = 12'd0;
  reg [11:0]  new_data_5 = 12'd0;

  reg led0 = 1'b0; 
  reg led1 = 1'b0; 
  reg led2 = 1'b0; 
  reg led3 = 1'b0; 
  reg led4 = 1'b0; 
  reg led5 = 1'b0; 

// internal wires

  /*here*/

// generate a signal named end_of_period which has '1' logic value at the end of the signal period

  /*here*/
  wire end_of_period = (counter_out == PULSE_PERIOD) ? 1'b1 : 1'b0;

// Create a counter from 0 to PULSE_PERIOD

  /*here*/
  always @(posedge pwm_clk) begin
    if(rstn == 0)
      counter_out <= 12'd0;
    else begin
      if(counter_out == PULSE_PERIOD)
        counter_out <= 12'd0;
      else 
        counter_out <= counter_out + 1;
    end
  end

// control the pwm signal value based on the input signal and counter value

  /*here*/
  always @(posedge pwm_clk) begin
    if(rstn == 0) begin
      led0 <= 1'b0; 
      led1 <= 1'b0; 
      led2 <= 1'b0; 
      led3 <= 1'b0; 
      led4 <= 1'b0; 
      led5 <= 1'b0; 
    end
    else begin

      if(new_data_0 > counter_out)
        led0 <= 1'b1;
      else
        led0 <= 1'b0;

      if(new_data_1 > counter_out)
        led1 <= 1'b1;
      else
        led1 <= 1'b0;

      if(new_data_2 > counter_out)
        led2 <= 1'b1;
      else
        led2 <= 1'b0;

      if(new_data_3 > counter_out)
        led3 <= 1'b1;
      else
        led3 <= 1'b0;
      
      if(new_data_4 > counter_out)
        led4 <= 1'b1;
      else
        led4 <= 1'b0;

      if(new_data_5 > counter_out)
        led5 <= 1'b1;
      else
        led5 <= 1'b0;
    end 
  end

// make sure that the new data is processed only after the END_OF_PERIOD

  /*here*/
  always @(posedge pwm_clk) begin
    if(rstn == 0) begin
      new_data_0 <= 12'd0;
      new_data_1 <= 12'd0;
      new_data_2 <= 12'd0;
      new_data_3 <= 12'd0;
      new_data_4 <= 12'd0;
      new_data_5 <= 12'd0;
    end
    else begin
        if(end_of_period == 1) begin
          new_data_0 <= data_channel_0;
          new_data_1 <= data_channel_1;
          new_data_2 <= data_channel_2;
          new_data_3 <= data_channel_3;
          new_data_4 <= data_channel_4;
          new_data_5 <= data_channel_5;
        end
    end
  end



// continous assigment of the correct PWM value for the LEDs
 /*here*/
  assign pwm_led_0 = led0;
  assign pwm_led_1 = led1;
  assign pwm_led_2 = led2;
  assign pwm_led_3 = led3;
  assign pwm_led_4 = led4;
  assign pwm_led_5 = led5;

endmodule
