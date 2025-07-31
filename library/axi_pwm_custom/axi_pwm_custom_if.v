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

  reg eop = 'd0;
  reg[11:0] cnt = 12'd0, dc0, dc1, dc2, dc3, dc4, dc5;
  reg pwml0 = 0, pwml1 = 0, pwml2 = 0, pwml3 = 0, pwml4 = 0, pwml5 = 0;

// internal wires

  /*here*/

  wire end_of_period;

// generate a signal named end_of_period which has '1' logic value at the end of the signal period

  /*here*/
  always @(posedge pwm_clk) begin
    eop = (cnt == PULSE_PERIOD) ? 1 : 0;
  end

// Create a counter from 0 to PULSE_PERIOD

  /*here*/
  always @(posedge pwm_clk) begin
    if(rstn) begin
      if(cnt == PULSE_PERIOD) begin
        cnt <= 12'd0;
      end
      else begin
        cnt <= cnt + 1'd1;
      end
    end
    else begin
      cnt <= 12'd0;
    end
  end

// control the pwm signal value based on the input signal and counter value

  /*here*/

  always @(posedge pwm_clk) begin
    if(rstn) begin
      if(dc0 > cnt) pwml0 <= 1'd1;
      else pwml0 <= 1'd0;
      if(dc1 > cnt) pwml1 <= 1'd1;
      else pwml1 <= 1'd0;
      if(dc2 > cnt) pwml2 <= 1'd1;
      else pwml2 <= 1'd0;
      if(dc3 > cnt) pwml3 <= 1'd1;
      else pwml3 <= 1'd0;
      if(dc4 > cnt) pwml4 <= 1'd1;
      else pwml4 <= 1'd0;
      if(dc5 > cnt) pwml5 <= 1'd1;
      else pwml5 <= 1'd0;
      end
      else begin
        pwml0 <= 1'd0;
        pwml1 <= 1'd0;
        pwml2 <= 1'd0;
        pwml3 <= 1'd0;
        pwml4 <= 1'd0;
        pwml5 <= 1'd0;
      end

  end

// make sure that the new data is processed only after the END_OF_PERIOD

  /*here*/
  always @(posedge pwm_clk) begin
    if(eop) begin 
      dc0 <= data_channel_0;
      dc1 <= data_channel_1;
      dc2 <= data_channel_2;
      dc3 <= data_channel_3;
      dc4 <= data_channel_4;
      dc5 <= data_channel_5;
    end
    else begin
      dc0 <= dc0;
      dc1 <= dc1;
      dc2 <= dc2;
      dc3 <= dc3;
      dc4 <= dc4;
      dc5 <= dc5;
    end
  end

// continous assigment of the correct PWM value for the LEDs

 /*here*/
  assign pwm_led_0 = pwml0;
  assign pwm_led_1 = pwml1;
  assign pwm_led_2 = pwml2;
  assign pwm_led_3 = pwml3;
  assign pwm_led_4 = pwml4;
  assign pwm_led_5 = pwml5;

endmodule
