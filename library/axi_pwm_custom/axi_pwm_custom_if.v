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
  output      reg     pwm_led_0,
  output      reg     pwm_led_1,
  output      reg     pwm_led_2,
  output      reg     pwm_led_3,
  output      reg     pwm_led_4,
  output      reg     pwm_led_5
);

localparam PULSE_PERIOD = 4095;

// internal registers

  reg [11:0] counter;
  reg [11:0] adc_0;
  reg [11:0] adc_1;
  reg [11:0] adc_2;
  reg [11:0] adc_3;
  reg [11:0] adc_4;
  reg [11:0] adc_5;
  reg end_of_period;

// generate a signal named end_of_period which has '1' logic value at the end of the signal period

  always @ (posedge pwm_clk) begin
    if (!rstn) begin
      end_of_period <= 1'b0;
    end else begin
      if(counter == PULSE_PERIOD) begin
        end_of_period <= 1'b1;
      end else begin
        end_of_period <= 1'b0;
      end
    end
  end

// Create a counter from 0 to PULSE_PERIOD

  always @ (posedge pwm_clk) begin
    if(!rstn) begin
      counter <= 12'd0;
    end else begin
      counter <= counter + 1'b1;
    end
  end

// Control the pwm signal value based on the input signal and counter value

  always @ (posedge pwm_clk) begin
    if(adc_0 > counter || !rstn) begin
      pwm_led_0 <= 1'b1;
    end else begin
      pwm_led_0 <= 1'b0;
    end

    if(adc_1 > counter || !rstn) begin
      pwm_led_1 <= 1'b1;
    end else begin
      pwm_led_1 <= 1'b0;
    end

    if(adc_2 > counter || !rstn) begin
      pwm_led_2 <= 1'b1;
    end else begin
      pwm_led_2 <= 1'b0;
    end

    if(adc_3 > counter || !rstn) begin
      pwm_led_3 <= 1'b1;
    end else begin
      pwm_led_3 <= 1'b0;
    end

    if(adc_4 > counter || !rstn) begin
      pwm_led_4 <= 1'b1;
    end else begin
      pwm_led_4 <= 1'b0;
    end

    if(adc_5 > counter || !rstn) begin
      pwm_led_5 <= 1'b1;
    end else begin
      pwm_led_5 <= 1'b0;
    end

  end

// Make sure that the new data is processed only after the END_OF_PERIOD

  always @ (posedge pwm_clk) begin
    if(!rstn || end_of_period) begin
      adc_0 <= data_channel_0;
      adc_1 <= data_channel_1;
      adc_2 <= data_channel_2;
      adc_3 <= data_channel_3;
      adc_4 <= data_channel_4;
      adc_5 <= data_channel_5;
    end
  end
endmodule
