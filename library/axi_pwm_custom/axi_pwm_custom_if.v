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
  output          pwm_led_1,
  output          pwm_led_2,
  output           pwm_led_3,
  output          pwm_led_4,
  output          pwm_led_5
);

  localparam PULSE_PERIOD = 4095;

// internal registers
  reg [11:0] cnt=12'h000;
  reg end_per;
  reg [11:0]aux_data_0;
  reg [11:0]aux_data_1;
  reg [11:0]aux_data_2;
  reg [11:0]aux_data_3;
  reg [11:0]aux_data_4;
  reg [11:0]aux_data_5;

  /*here*/

// internal wires
  reg l0,l1, l2, l3, l4, l5;

  /*here*/

// generate a signal named end_of_period which has '1' logic value at the end of the signal period

  /*here*/
  always @(posedge pwm_clk) begin
   end_per=(cnt==PULSE_PERIOD)? 1:0;
  end

// Create a counter from 0 to PULSE_PERIOD
  always @(posedge pwm_clk) begin
    if(rstn==1'b0)begin
      l0<=1'b0;
      l1<=1'b0;
      l2<=1'b0;
      l3<=1'b0;
      l4<=1'b0;
      l5<=1'b0;
      cnt<=12'd0;

    end
    else begin
      if(cnt==PULSE_PERIOD) begin
        cnt<=12'd0;
        
      end
      else
          cnt<=cnt+12'd1;

    end

  end

  /*here*/

// control the pwm signal value based on the input signal and counter value
  always @(posedge pwm_clk)begin
    if(cnt < aux_data_0) begin
      l0<=1'b1;
    end
    else
       l0<=1'b0;
    if(cnt < aux_data_1) begin
      l1<=1'b1;
    end
    else
       l1<=1'b0;
    if(cnt < aux_data_2) begin
      l2<=1'b1;
    end
    else
       l2<=1'b0;
     if(cnt < aux_data_3) begin
      l3<=1'b1;
    end
    else
      l3<=1'b0;
    if(cnt < aux_data_4) begin
      l4<=1'b1;
    end
    else
       l4<=1'b0;
    if(cnt < aux_data_5) begin
      l5<=1'b1;
    end
    else
       l5<=1'b0;
  end

  /*here*/

// make sure that the new data is processed only after the END_OF_PERIOD
  always @(posedge pwm_clk) begin
    if(end_per) begin
      aux_data_0<=data_channel_0;
      aux_data_1<=data_channel_0;
      aux_data_2<=data_channel_0;
      aux_data_3<=data_channel_0;
      aux_data_4<=data_channel_0;
      aux_data_5<=data_channel_0;
    

    end
    else begin
      aux_data_0<=aux_data_0;
      aux_data_1<=aux_data_1;
      aux_data_2<=aux_data_2;
      aux_data_3<=aux_data_3;
      aux_data_4<=aux_data_4;
      aux_data_5<=aux_data_5;
    end
  end


  /*here*/

// continous assigment of the correct PWM value for the LEDs

 /*here*/
  assign pwm_led_0=l0;
  assign pwm_led_1=l1;
  assign pwm_led_2=l2;
  assign pwm_led_3=l3;
  assign pwm_led_4=l4;
  assign pwm_led_5=l5;


  


endmodule
