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

  reg[11:0] counter=12'h000;
  reg end_of_period;
  reg[11:0] aux_data_0;
  reg[11:0] aux_data_1;
  reg[11:0] aux_data_2;
  reg[11:0] aux_data_3;
  reg[11:0] aux_data_4;
  reg[11:0] aux_data_5;
  reg led_0;
  reg led_1;
  reg led_2;
  reg led_3;
  reg led_4;
  reg led_5;

// internal wires



// generate a signal named end_of_period which has '1' logic value at the end of the signal period

  always @(posedge pwm_clk) begin
    end_of_period <= (counter == PULSE_PERIOD) ? 1 : 0;
  end

// Create a counter from 0 to PULSE_PERIOD

  always @(posedge pwm_clk) begin
      if(!rstn) begin
        led_0 <= 1'b0;
        led_1 <= 1'b0;
        led_2 <= 1'b0;
        led_3 <= 1'b0;
        led_4 <= 1'b0;
        led_5 <= 1'b0;
        counter <= 12'h000;
      end else if(counter == PULSE_PERIOD) begin
          counter <=12'h000;
      end else begin
          counter <= counter + 12'h001;
      end
  end

// control the pwm signal value based on the input signal and counter value

  always @(posedge pwm_clk) begin

    if(counter > aux_data_0) begin
        led_0 <= 1'b0;
    end else 
        led_0 <= 1'b1;
  

    if(counter > aux_data_1) begin
        led_1 <= 1'b0;
    end else
        led_1 <= 1'b1;


    if(counter > aux_data_2) begin
        led_2 <= 1'b0;
    end else 
        led_2 <= 1'b1;
  

    if(counter > aux_data_3) begin
        led_3 <= 1'b0;
    end else 
        led_3 <= 1'b1;


    if(counter >aux_data_4) begin
        led_4 <= 1'b0;
    end else 
        led_4 <= 1'b1;


    if(counter > aux_data_5) begin
        led_5 <= 1'b0;
    end else 
        led_5 <= 1'b1;
  
  end

// make sure that the new data is processed only after the END_OF_PERIOD

  always @(posedge pwm_clk) begin
    if(end_of_period) begin
      aux_data_0 <= data_channel_0;
      aux_data_1 <= data_channel_1;
      aux_data_2 <= data_channel_2;
      aux_data_3 <= data_channel_3;
      aux_data_4 <= data_channel_4;
      aux_data_5 <= data_channel_5;
    end else begin
      aux_data_0 <= aux_data_0;
      aux_data_1 <= aux_data_1;
      aux_data_2 <= aux_data_2;
      aux_data_3 <= aux_data_3;
      aux_data_4 <= aux_data_4;
      aux_data_5 <= aux_data_5;
    end
  end

// continous assigment of the correct PWM value for the LEDs

    assign pwm_led_0 = led_0;
    assign pwm_led_1 = led_1;
    assign pwm_led_2 = led_2;
    assign pwm_led_3 = led_3;
    assign pwm_led_4 = led_4;
    assign pwm_led_5 = led_5;

endmodule
