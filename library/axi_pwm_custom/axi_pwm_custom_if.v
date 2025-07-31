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

  reg end_of_period = 1'b0;
  reg [11:0] count_value = 12'h000;
  reg flag = 1'b0;

  reg [11:0] data_0;
  reg [11:0] data_1;
  reg [11:0] data_2;
  reg [11:0] data_3;
  reg [11:0] data_4;
  reg [11:0] data_5;

  reg w_pwm_led_0 = 1'b0;
  reg w_pwm_led_1 = 1'b0;
  reg w_pwm_led_2 = 1'b0;
  reg w_pwm_led_3 = 1'b0;
  reg w_pwm_led_4 = 1'b0;
  reg w_pwm_led_5 = 1'b0;


  // internal wires



  // generate a signal named end_of_period which has '1' logic value at the end of the signal period

  /*here*/
  always @(posedge pwm_clk)
  begin

    if(!rstn)
    begin
      end_of_period <= 1'b0;
    end

    else
    begin
      if  (count_value == PULSE_PERIOD)
      begin
        end_of_period <= 1'b1;
      end

      else
      begin
        end_of_period <= 1'b0;
      end
    end
  end


  // Create a counter from 0 to PULSE_PERIOD

  always @(posedge pwm_clk)
  begin

    if (!rstn)
    begin
      count_value <= 12'h000;
    end

    else
    begin
      if (!end_of_period)
      begin
        count_value <= count_value + 12'h001;
      end
      else
      begin
        count_value <= 12'h000;
      end

    end


  end

  // control the pwm signal value based on the input signal and counter value

  /*here*/
  always @(posedge pwm_clk)
  begin

    if (!rstn)
    begin
      w_pwm_led_0 <= 1'b0;
      w_pwm_led_1 <= 1'b0;
      w_pwm_led_2 <= 1'b0;
      w_pwm_led_3 <= 1'b0;
      w_pwm_led_4 <= 1'b0;
      w_pwm_led_5 <= 1'b0;
    end

    else
    begin
      if(count_value < data_0)
      begin
        w_pwm_led_0 <= 1'b1;
      end
      else
      begin
        w_pwm_led_0 <= 1'b0;
      end

      if(count_value < data_1)
      begin
        w_pwm_led_1 <= 1'b1;
      end
      else
      begin
        w_pwm_led_1 <= 1'b0;
      end

      if(count_value < data_2)
      begin
        w_pwm_led_2 <= 1'b1;
      end
      else
      begin
        w_pwm_led_2 <= 1'b0;
      end

      if(count_value < data_3)
      begin
        w_pwm_led_3 <= 1'b1;
      end
      else
      begin
        w_pwm_led_3 <= 1'b0;
      end

      if(count_value < data_4)
      begin
        w_pwm_led_4 <= 1'b1;
      end
      else
      begin
        w_pwm_led_4 <= 1'b0;
      end

      if(count_value < data_5)
      begin
        w_pwm_led_5 <= 1'b1;
      end
      else
      begin
        w_pwm_led_5 <= 1'b0;
      end

    end
  end

  // make sure that the new data is processed only after the END_OF_PERIOD

  always @(posedge pwm_clk)
  begin

    if (!rstn)
    begin
      data_0 <= 12'h000;
      data_1 <= 12'h000;
      data_2 <= 12'h000;
      data_3 <= 12'h000;
      data_4 <= 12'h000;
      data_5 <= 12'h000;
    end

    else
    begin
      if(end_of_period)
      begin
        data_0 <= data_channel_0;
        data_1 <= data_channel_1;
        data_2 <= data_channel_2;
        data_3 <= data_channel_3;
        data_4 <= data_channel_4;
        data_5 <= data_channel_5;
      end

      else
      begin
        data_0 <= data_0;
        data_1 <= data_1;
        data_2 <= data_2;
        data_3 <= data_3;
        data_4 <= data_4;
        data_5 <= data_5;
      end
    end

  end

  // continous assigment of the correct PWM value for the LEDs

  assign pwm_led_0 = w_pwm_led_0;
  assign pwm_led_1 = w_pwm_led_1;
  assign pwm_led_2 = w_pwm_led_2;
  assign pwm_led_3 = w_pwm_led_3;
  assign pwm_led_4 = w_pwm_led_4;
  assign pwm_led_5 = w_pwm_led_5;

  /*here*/

endmodule
