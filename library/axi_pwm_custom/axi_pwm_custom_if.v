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
  reg [11:0] cnt;
  reg [11:0] reg0_adc;
  reg [11:0] reg1_adc;
  reg [11:0] reg2_adc;
  reg [11:0] reg3_adc;
  reg [11:0] reg4_adc;
  reg [11:0] reg5_adc;
  reg  reg0_led;
  reg  reg1_led;
  reg reg2_led;
  reg reg3_led;
  reg reg4_led;
  reg  reg5_led;


  

// internal wires

  /*here*/

// generate a signal named end_of_period which has '1' logic value at the end of the signal period


// Create a counter from 0 to PULSE_PERIOD

  always @(posedge pwm_clk) begin
    if(rstn == 1'b0) begin
      END_OF_PERIOD <= 0;
      cnt <= 0;
    end
    else begin
      if(cnt < PULSE_PERIOD) begin
        cnt <= cnt + 1;
      end
      else begin 
       END_OF_PERIOD <= 1; 
       cnt=0;
    end
  end
end


// control the pwm signal value based on the input signal and counter value
always @(posedge pwm_clk) begin
    if(rstn == 1'b0) begin
       reg0_led <= 1;
       reg1_led <= 1;
       reg2_led <= 1;
       reg3_led <= 1;
       reg4_led <= 1;
       reg5_led <= 1;

    end
    else begin
      if(reg0_adc > cnt) begin
        reg0_led <= 1;
      end
      else begin
        reg0_led <= 0;
      end
       if(reg1_adc>cnt) begin
        reg1_led <= 1;
      end
      else begin
        reg1_led <= 0;
      end
      if(reg2_adc>cnt) begin
        reg2_led <= 1;
      end
      else begin
        reg2_led <= 0;
      end
      if(reg3_adc>cnt) begin
        reg3_led <= 1;
      end
      else begin
        reg3_led <= 0;
      end
      if(reg4_adc>cnt) begin
        reg4_led <= 1;
      end
      else begin
        reg4_led <= 0;
      end
      if(reg5_adc>cnt) begin
        reg5_led <= 1;
      end
      else begin
        reg5_led <= 0;
      end
    end
  end
  

// make sure that the new data is processed only after the END_OF_PERIOD
always @(posedge pwm_clk) begin
  if(rstn == 0) begin
    reg0_adc <=  data_channel_0;
    reg1_adc <= data_channel_1;
    reg2_adc <= data_channel_2;
    reg3_adc <= data_channel_3;
    reg4_adc <= data_channel_4;
    reg5_adc <= data_channel_5;

  end
  else
  if(END_OF_PERIOD == 1) begin
    reg0_adc <=  data_channel_0;
    reg1_adc <= data_channel_1;
    reg2_adc <= data_channel_2;
    reg3_adc <= data_channel_3;
    reg4_adc <= data_channel_4;
    reg5_adc <= data_channel_5;

  end
   
end

// continous assigment of the correct PWM value for the LEDs

 /*here*/
   assign pwm_led_0 = reg0_led;
   assign pwm_led_1 = reg1_led;
   assign pwm_led_2 = reg2_led;
   assign pwm_led_3 = reg3_led;
   assign pwm_led_4 = reg4_led;
   assign pwm_led_5 = reg5_led;

endmodule
