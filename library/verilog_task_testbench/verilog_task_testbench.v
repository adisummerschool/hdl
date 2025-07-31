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
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************
// This is the LVDS/DDR interface

`timescale 1ns/100ps

module verilog_task_testbench ( 

  input            ref_clk,
  input            rstn,
  output reg  [11:0]  triangle_wave
);

reg dir;//0-up, 1-down

always @(posedge ref_clk or negedge rstn) begin
  if (!rstn) begin
    triangle_wave <= 12'h000;
    dir <= 1'b0;
  end else begin
    if(!dir) begin
      if(triangle_wave == 12'hFFF) begin
        dir <= 1'b1;
        triangle_wave <= triangle_wave - 1'b1;
      end else begin
        triangle_wave <= triangle_wave + 1'b1;
      end
    end else begin
      if(triangle_wave == 12'h000) begin  
        dir <= 1'b0;
        triangle_wave <= triangle_wave + 1'b1;
      end else begin
        triangle_wave <= triangle_wave - 1'b1;
      end
    end
  end
end

endmodule