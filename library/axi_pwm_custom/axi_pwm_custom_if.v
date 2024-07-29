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

  reg   [11:0]  data_channel_0_aux   = 12'b0;
  reg   [11:0]  data_channel_1_aux   = 12'b0;
  reg   [11:0]  data_channel_2_aux   = 12'b0;
  reg   [11:0]  data_channel_3_aux   = 12'b0;
  reg   [11:0]  data_channel_4_aux   = 12'b0;
  reg   [11:0]  data_channel_5_aux   = 12'b0;

   reg  [11:0]  counter = 12'b0; // global counter
   reg          end_of_period = 1'b0; // end of period

   // out led signals
   reg          out_led_0;
   reg          out_led_1;
   reg          out_led_2;
   reg          out_led_3;
   reg          out_led_4;
   reg          out_led_5;
  

  // internal wires

  /*here*/

// generate a signal named end_of_period which has '1' logic value at the end of the signal period

  always @(posedge pwm_clk) // end_of_period signal generation
  begin
    if (counter < PULSE_PERIOD) end_of_period <= 1'b0;
    else end_of_period <= 1'b1; 
  end

// Create a counter from 0 to PULSE_PERIOD

  always @(posedge pwm_clk) // global counter
  begin
  	if (!rstn) 
  		counter <= 12'b0;
	else
	    if (counter < PULSE_PERIOD) 
	    	counter <= counter + 1;
	    else counter <= 12'b0; 
  end

// control the pwm signal value based on the input signal and counter value

  // PWM signal 0 to led 0
  always @(posedge pwm_clk)
  begin
     if (data_channel_0 > counter) out_led_0 <= 1'b1;
     else out_led_0 <= 1'b0;
  end 

  // PWM signal 0 to led 0
  always @(posedge pwm_clk)
  begin
     if (data_channel_0 > counter) out_led_0 <= 1'b1;
     else out_led_0 <= 1'b0;
  end 

  // PWM signal 1 to led 1
  always @(posedge pwm_clk)
  begin
     if (data_channel_1 > counter) out_led_1 <= 1'b1;
     else out_led_1 <= 1'b0;
  end 

  // PWM signal 2 to led 2
  always @(posedge pwm_clk)
  begin
     if (data_channel_2 > counter) out_led_2 <= 1'b1;
     else out_led_2 <= 1'b0;
  end 

  // PWM signal 3 to led 3
  always @(posedge pwm_clk)
  begin
     if (data_channel_3 > counter) out_led_3 <= 1'b1;
     else out_led_3 <= 1'b0;
  end 

  // PWM signal 4 to led 4
  always @(posedge pwm_clk)
  begin
     if (data_channel_4 > counter) out_led_4 <= 1'b1;
     else out_led_4 <= 1'b0;
  end 

  // PWM signal 5 to led 5
  always @(posedge pwm_clk)
  begin
     if (data_channel_5 > counter) out_led_5 <= 1'b1;
     else out_led_5 <= 1'b0;
  end 
   
assign  pwm_led_0 = out_led_0;
assign  pwm_led_1 = out_led_1;
assign  pwm_led_2 = out_led_2;
assign  pwm_led_3 = out_led_3;
assign  pwm_led_4 = out_led_4;
assign  pwm_led_5 = out_led_5;

// make sure that the new data is processed only after the END_OF_PERIOD

  always @(posedge pwm_clk)
  begin
    if (end_of_period == 1'b1) 
    begin
    data_channel_0_aux = data_channel_0;
    data_channel_1_aux = data_channel_1;
    data_channel_2_aux = data_channel_2;
    data_channel_3_aux = data_channel_3;
    data_channel_4_aux = data_channel_4;
    data_channel_5_aux = data_channel_5;
    end
  end

endmodule
