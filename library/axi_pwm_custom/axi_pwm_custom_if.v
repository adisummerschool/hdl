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

  reg [11:0]cnt=12'hFFF;
  wire END_OF_PERIOD;
  reg l0=1'b0;
  reg l1=1'b0;
  reg l2=1'b0;
  reg l3=1'b0;
  reg l4=1'b0;
  reg l5=1'b0;
  reg [11:0]d0=12'h000;
  reg [11:0]d1=12'h000;
  reg [11:0]d2=12'h000;
  reg [11:0]d3=12'h000;
  reg [11:0]d4=12'h000;
  reg [11:0]d5=12'h000;


  // internal wires

  /*here*/

  // Create a counter from 0 to PULSE_PERIOD

  always @(posedge pwm_clk)
    begin
      if(rstn==0)
        cnt<=0;
      else
        if(END_OF_PERIOD == 1'b1)
          cnt<=0;
        else
          cnt<=cnt+1;
    end

// generate a signal named end_of_period which has '1' logic value at the end of the signal period

  assign END_OF_PERIOD=(cnt==PULSE_PERIOD)?1'b1:1'b0;

// make sure that the new data is processed only after the END_OF_PERIOD
always @(posedge pwm_clk)
    begin
       if(END_OF_PERIOD == 1'b1) begin 
        d0 <= data_channel_0;
        d1 <= data_channel_1;
        d2 <= data_channel_2;
        d3 <= data_channel_3;
        d4 <= data_channel_4;
        d5 <= data_channel_5;
        end

    end


// control the pwm signal value based on the input signal and counter value

  always @(posedge pwm_clk)
    begin
      if(cnt<d0)
        l0<=1'b1;
      else
        l0<=1'b0;
    end
  assign pwm_led_0=l0;

  always @(posedge pwm_clk)
    begin
      if(cnt<d1)
        l1<=1'b1;
      else
        l1<=1'b0;
    end
  assign pwm_led_1=l1;
  
  always @(posedge pwm_clk)
    begin
      if(cnt<d2)
        l2<=1'b1;
      else
        l2<=1'b0;
    end
  assign pwm_led_2=l2;

  always @(posedge pwm_clk)
    begin
      if(cnt<d3)
        l3<=1'b1;
      else
        l3<=1'b0;
    end
  assign pwm_led_3=l3;

  always @(posedge pwm_clk)
    begin
      if(cnt<d4)
        l4<=1'b1;
      else
        l4<=1'b0;
    end
  assign pwm_led_4=l4;

always @(posedge pwm_clk)
    begin
      if(cnt<d5)
        l5<=1'b1;
      else
        l5<=1'b0;
    end
  assign pwm_led_5=l5;


endmodule
