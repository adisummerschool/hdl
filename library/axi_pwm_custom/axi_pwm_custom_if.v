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
  reg [11:0] data_channel0;
  reg [11:0] data_channel1;
  reg [11:0] data_channel2;
  reg [11:0] data_channel3;
  reg [11:0] data_channel4;
  reg [11:0] data_channel5;


  reg [11:0] val_c;

  reg true_led0;
  reg true_led1;
  reg true_led2;
  reg true_led3;
  reg true_led4;
  reg true_led5;

  reg end_of_period;

// internal wires

  /*here*/


// generate a signal named end_of_period which has '1' logic value at the end of the signal period

  /*here*/
    always @(posedge pwm_clk) begin
      if(rstn == 0) begin
        end_of_period <= 0;
      end else if(val_c == PULSE_PERIOD) begin
        end_of_period <= 1'b1;
      end else begin
        end_of_period <= 1'b0;
      end
    end

// Create a counter from 0 to PULSE_PERIOD

  /*here*/
    always @(posedge pwm_clk) begin
      if(rstn == 0) begin
        val_c <= 0;
      end else begin
        val_c <= val_c + 1;
      end
    end

    
// control the pwm signal value based on the input signal and counter value

  /*here*/
  always @(posedge pwm_clk) begin 
        if(data_channel0 > val_c || !rstn) begin
          true_led0 <= 1'b1;
        end else begin
          true_led0 <= 1'b0;
        end
    
        if(data_channel1 > val_c|| !rstn) begin
          true_led1 <= 1'b1;
        end else begin
          true_led1 <= 1'b0;
        end
     
        if(data_channel2 > val_c|| !rstn) begin
          true_led2 <= 1'b1;
        end else begin
          true_led2 <= 1'b0;
        end
            
        if(data_channel3 > val_c || !rstn) begin
          true_led3 <= 1'b1;
        end else begin
          true_led3 <= 1'b0;
        end
            
        if(data_channel4 > val_c || !rstn) begin
          true_led4 <= 1'b1;
        end else begin
          true_led4 <= 1'b0;
        end  

        if(data_channel5 > val_c || !rstn) begin
          true_led5 <= 1'b1;
        end else begin
          true_led5 <= 1'b0;
        end
     end

// make sure that the new data is processed only after the END_OF_PERIOD

  /*here*/
   always @(posedge pwm_clk) begin
      if(end_of_period == 1'b1) begin
        data_channel0 <= data_channel_0;
        data_channel1 <= data_channel_1;
        data_channel2 <= data_channel_2;
        data_channel3 <= data_channel_3;
        data_channel4 <= data_channel_4;
        data_channel5 <= data_channel_5;
      end else begin
      if(rstn == 1'b0) begin
        data_channel0 <= data_channel_0;
        data_channel1 <= data_channel_1;
        data_channel2 <= data_channel_2;
        data_channel3 <= data_channel_3;
        data_channel4 <= data_channel_4;
        data_channel5 <= data_channel_5;
      end 
    end
  end


// continous assigment of the correct PWM value for the LEDs

 /*here*/
  assign pwm_led_0 = true_led0;
  assign pwm_led_1 = true_led1;
  assign pwm_led_2 = true_led2;
  assign pwm_led_3 = true_led3;
  assign pwm_led_4 = true_led4;
  assign pwm_led_5 = true_led5;  
    

endmodule
