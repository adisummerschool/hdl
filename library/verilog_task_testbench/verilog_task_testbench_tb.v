// ***************************************************************************
// ***************************************************************************
// Copyright 2022 - 2023(c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL(Verilog or VHDL) components. The individual modules are
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
//      of this repository(LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository(LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module verilog_task_testbench_tb;
  parameter VCD_FILE = "verilog_task_testbench_tb.vcd";

 // `define TIMEOUT 900
  reg ref_clk = 0;
  reg rstn = 0;
  wire [11:0] triangle_wave;

  
  verilog_task_testbench task_tb_dut (
    .ref_clk(ref_clk),
    .rstn(rstn),
    .triangle_wave(triangle_wave)
  );

  
 
 
//  task counter(input integer n);
//    integer i;
//    begin
//      for (i = 0; i < n; i = i + 1)
//        @(posedge ref_clk);
//    end
//  endtask
  initial begin
    $monitor("time=%0t rstn=%b triangle_wave=%h", $time, rstn, triangle_wave);
    #100 rstn = 1;

//    repeat (10) begin
//      rstn = 1'b1; counter(5);
//      rstn = 1'b0; counter(5);
//    end

   // rstn = 1'b1;
   // counter(100);
    //#10000 
    #10000 $finish;
  end
   always #5 ref_clk = ~ref_clk;
   //verilog_task_testbench task_tb_dut (ref_clk,rstn,triangle_wave);
endmodule