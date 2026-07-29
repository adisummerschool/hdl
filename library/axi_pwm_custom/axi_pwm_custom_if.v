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

  reg END_OF_PERIOD;
  reg [11:0] counter;
  reg [11:0] adc_reg0, adc_reg1, adc_reg2, adc_reg3, adc_reg4, adc_reg5;
  reg led_reg0, led_reg1, led_reg2, led_reg3, led_reg4, led_reg5;

// internal wires

  /*here*/

// generate a signal named end_of_period which has '1' logic value at the end of the signal period

  always @(posedge pwm_clk) begin
    if (rstn == 0) begin
      END_OF_PERIOD <= 0;
    end
    else begin
      if (counter == PULSE_PERIOD) begin
          END_OF_PERIOD <= 1;
        end
    end
  end

// make sure that the new data is processed only after the END_OF_PERIOD

  always @(posedge pwm_clk) begin
    if (rstn == 0) begin
      adc_reg0 <= data_channel_0;
      adc_reg1 <= data_channel_1;
      adc_reg2 <= data_channel_2;
      adc_reg3 <= data_channel_3;
      adc_reg4 <= data_channel_4;
      adc_reg5 <= data_channel_5;
    end
    else begin
      if (END_OF_PERIOD) begin
      adc_reg0 <= data_channel_0;
      adc_reg1 <= data_channel_1;
      adc_reg2 <= data_channel_2;
      adc_reg3 <= data_channel_3;
      adc_reg4 <= data_channel_4;
      adc_reg5 <= data_channel_5;
      end
    end
  end

// Create a counter from 0 to PULSE_PERIOD

  always @(posedge pwm_clk) begin
    if (rstn == 0) begin
      counter <= 0;
    end
    else begin
      if (counter == PULSE_PERIOD) begin
       counter <= 0;
      end
      else begin
        counter <= counter + 1;
      end
    end
  end

// control the pwm signal value based on the input signal and counter value

  always @(posedge pwm_clk) begin
      // LED 0
      if (adc_reg0 > counter || !rstn) begin
        led_reg0 <= 1;
      end
      else begin
        led_reg0 <= 0;
      end
      // LED 1
      if (adc_reg1 > counter || !rstn) begin
        led_reg1 <= 1;
      end
      else begin
        led_reg1 <= 0;
      end
      // LED 2
      if (adc_reg2 > counter || !rstn) begin
        led_reg2 <= 1;
      end
      else begin
        led_reg2 <= 0;
      end
      // LED 3
      if (adc_reg3 > counter || !rstn) begin
        led_reg3 <= 1;
      end
      else begin
        led_reg3 <= 0;
      end
      // LED 4
      if (adc_reg4 > counter || !rstn) begin
        led_reg4 <= 1;
      end
      else begin
        led_reg4 <= 0;
      end
      // LED 5
      if (adc_reg5 > counter || !rstn) begin
        led_reg5 <= 1;
      end
      else begin
        led_reg5 <= 0;
      end
  end

// continous assigment of the correct PWM value for the LEDs

 assign pwm_led_0 = led_reg0;
 assign pwm_led_1 = led_reg1;
 assign pwm_led_2 = led_reg2;
 assign pwm_led_3 = led_reg3;
 assign pwm_led_4 = led_reg4;
 assign pwm_led_5 = led_reg5;

endmodule
