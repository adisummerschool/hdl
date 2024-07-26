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
 reg[11:0] pulse_per_cnt = 12'h000;
 reg[11:0] data_ch0_sig;
 reg[11:0] data_ch1_sig ;
 reg[11:0] data_ch2_sig ;
 reg[11:0] data_ch3_sig ;
 reg[11:0] data_ch4_sig ;
 reg[11:0] data_ch5_sig ;
 
  // internal wires

  /*here*/
wire end_of_period;

// generate a signal named end_of_period which has '1' logic value at the end of the signal period

  /*here*/
assign end_of_period=(PULSE_PERIOD==pulse_per_cnt)?1'b1:1'b0;


// Create a counter from 0 to PULSE_PERIOD

  /*here*/
always@(posedge pwm_clk) begin
  if(rstn==0) begin
    pulse_per_cnt<= 12'h000;
  end else  if(pulse_per_cnt==PULSE_PERIOD) begin
  pulse_per_cnt=12'h000;
end else begin

  pulse_per_cnt<=pulse_per_cnt+ 1'b1;

end
end

// control the pwm signal value based on the input signal and counter value

assign pwm_led_0 =(data_ch0_sig==0)?1'b0:1'b1;
assign pwm_led_1 =(data_ch1_sig==0)?1'b0:1'b1;
assign pwm_led_2 =(data_ch2_sig==0)?1'b0:1'b1;
assign pwm_led_3 =(data_ch3_sig==0)?1'b0:1'b1;
assign pwm_led_4 =(data_ch4_sig==0)?1'b0:1'b1;
assign pwm_led_5 =(data_ch5_sig==0)?1'b0:1'b1;

  /*here*/

// make sure that the new data is processed only after the END_OF_PERIOD

  /*here*/
always@(posedge pwm_clk) begin
  if(pulse_per_cnt==12'h000 || end_of_period==1'b1) begin
  data_ch0_sig<= data_channel_0;
  data_ch1_sig<=data_channel_1;
  data_ch2_sig<=data_channel_2;
  data_ch3_sig<=data_channel_3;
  data_ch4_sig<=data_channel_4;
  data_ch5_sig<=data_channel_5; 
  
end else begin
  data_ch0_sig<=(data_ch0_sig==0)? 12'h000:data_ch0_sig-1'b1;
  data_ch1_sig<=(data_ch1_sig==0)? 12'h000:data_ch1_sig-1'b1;
  data_ch2_sig<=(data_ch2_sig==0)? 12'h000:data_ch2_sig-1'b1;
  data_ch3_sig<=(data_ch3_sig==0)? 12'h000:data_ch3_sig-1'b1;
  data_ch4_sig<=(data_ch4_sig==0)? 12'h000:data_ch4_sig-1'b1;
  data_ch5_sig<=(data_ch5_sig==0)? 12'h000:data_ch5_sig-1'b1;
  
end
end
endmodule
