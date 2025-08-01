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
  output reg         pwm_led_0,
  output reg          pwm_led_1,
  output reg          pwm_led_2,
  output reg          pwm_led_3,
  output reg          pwm_led_4,
  output reg          pwm_led_5
);

  localparam PULSE_PERIOD = 4095;

// internal registers

  reg [11:0]count;
  reg end_of_period;
  reg [11:0]pwm_signal;
  reg in_signal;

// internal wires

  reg [11:0]internal0;
  reg [11:0]internal1;
  reg [11:0]internal2;
  reg [11:0]internal3;
  reg [11:0]internal4;
  reg [11:0]internal5;

  reg  aux_pwm_led_0;
  reg  aux_pwm_led_1;
  reg  aux_pwm_led_2;
  reg  aux_pwm_led_3;
  reg  aux_pwm_led_4;
  reg  aux_pwm_led_5;


  
// generate a signal named end_of_period which has '1' logic value at the end of the signal period
//always@(posedge clk)
//if(count == 3'h111) begin
//end_of_period <= 1'b1;  
//end

  

// Create a counter from 0 to PULSE_PERIOD

  /*here*/
  always@(posedge pwm_clk) begin

  if(!rstn) begin

    count <= 12'b000000000000;
    end_of_period <= 0;
  
  end  else begin
  
    if (count < 12'b111111111111) begin

    count <= count + 1;  
    end_of_period <= 1;
  
  end else begin
  
    count <= 12'b000000000000;
    end_of_period <= 0;
  
  end
  end
end

// control the pwm signal value based on the input signal and counter value

  always@(posedge pwm_clk)begin

  if(internal0 > count) begin

    aux_pwm_led_0 <= 1'b1;
  
  end else begin
  
    aux_pwm_led_0 <= 1'b0;
  
  end
  
  if(internal1 > count) begin
  
    aux_pwm_led_1 <= 1'b1;
  
  end else begin
  
    aux_pwm_led_1 <= 1'b0;
  
  end
  
  if(internal2 > count) begin
  
    aux_pwm_led_2 <= 1'b1;
  
  end else begin
  
    aux_pwm_led_2 <= 1'b0;
  
  end
  
  if(internal3 > count) begin
  
    aux_pwm_led_3 <= 1'b1;
  
  end else begin
  
    aux_pwm_led_3 <= 1'b0;
  
  end

  if(internal4 > count) begin
  
    aux_pwm_led_4 <= 1'b1;
  
  end else begin
  
    aux_pwm_led_4 <= 1'b0;
  
  end
  
  if(internal5 > count) begin
  
    aux_pwm_led_5 <= 1'b1;
  
  end else begin
  
    aux_pwm_led_5 <= 1'b0;
  
  end
  end


// make sure that the new data is processed only after the END_OF_PERIOD

  /*here*/
  always@(posedge pwm_clk) begin
  if(end_of_period == 1'b1) begin

      internal0 <= data_channel_0;
      internal1 <= data_channel_1;
      internal2 <= data_channel_2;
      internal3 <= data_channel_3;
      internal4 <= data_channel_4;  
      internal5 <= data_channel_5;
  
    end else begin
  
      internal0 <= internal0;
      internal1 <= internal1;
      internal2 <= internal2;
      internal3 <= internal3;
      internal4 <= internal4;  
      internal5 <= internal5;
  
    end
  
  end

// continous assigment of the correct PWM value for the LEDs
  always@(posedge pwm_clk) begin

    pwm_led_0 <= aux_pwm_led_0;
    pwm_led_1 <= aux_pwm_led_1;
    pwm_led_2 <= aux_pwm_led_2;
    pwm_led_3 <= aux_pwm_led_3;
    pwm_led_4 <= aux_pwm_led_4;
    pwm_led_5 <= aux_pwm_led_5;

  end

 /*here*/

endmodule
