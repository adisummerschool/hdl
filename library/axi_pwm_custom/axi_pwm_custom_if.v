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
  output           pwm_led_0_r,
  output           pwm_led_0_g,
  output           pwm_led_0_b,
  output           pwm_led_1_r,
  output           pwm_led_1_g,
  output           pwm_led_1_b
);

  localparam PULSE_PERIOD = 4095;
  
  // internal registers

  reg [11:0] count = 12'b0;
  reg [11:0] data_ch_0;
  reg [11:0] data_ch_1;
  reg [11:0] data_ch_2;
  reg [11:0] data_ch_3;
  reg [11:0] data_ch_4;
  reg [11:0] data_ch_5;

  reg led0;
  reg led1;
  reg led2;
  reg led3;
  reg led4;
  reg led5;

  /*here*/

  // internal wires
  wire end_of_period;

  /*here*/

// generate a signal named end_of_period which has '1' logic value at the end of the signal period
    assign end_of_period = (count == PULSE_PERIOD) ? 1'b1 : 1'b0;
  
  /*here*/

// Create a counter from 0 to PULSE_PERIOD

  always@(posedge pwm_clk)
  begin
    if(!rstn) 
      count <= 12'b0;
    else 
      if(count < PULSE_PERIOD)
        count <= count + 1;
      else
        count <= 12'b0;
  end

  /*here*/


// control the pwm signal value based on the input signal and counter value
  always@(posedge pwm_clk)
  begin
    led0 = (count < data_ch_0) ? 1'b1 : 1'b0;
    led1 = (count < data_ch_1) ? 1'b1 : 1'b0;
    led2 = (count < data_ch_2 ) ? 1'b1 : 1'b0;
    led3 = (count < data_ch_3 ) ? 1'b1 : 1'b0;
    led4 = (count < data_ch_4 ) ? 1'b1 : 1'b0;
    led5 = (count < data_ch_5 ) ? 1'b1 : 1'b0;
  end
  /*here*/

// make sure that the new data is processed only after the END_OF_PERIOD
  always@(negedge end_of_period)
  begin
    data_ch_0 <= data_channel_0;
    data_ch_1 <= data_channel_1;
    data_ch_2 <= data_channel_2;
    data_ch_3 <= data_channel_3;
    data_ch_4 <= data_channel_4;
    data_ch_5 <= data_channel_5;
  end
  /*here*/


  assign pwm_led_0_r = led0;
  assign pwm_led_0_g = led1;
  assign pwm_led_0_b = led2;
  assign pwm_led_1_r = led3;
  assign pwm_led_1_g = led4;
  assign pwm_led_1_b = led5;

endmodule