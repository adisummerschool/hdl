// ***************************************************************************
// ***************************************************************************
// Copyright 2019 - 2023 (c) Analog Devices, Inc. All rights reserved.
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

`timescale 1ns/100ps

module system_top (

  inout   [14:0]  ddr_addr,
  inout   [ 2:0]  ddr_ba,
  inout           ddr_cas_n,
  inout           ddr_ck_n,
  inout           ddr_ck_p,
  inout           ddr_cke,
  inout           ddr_cs_n,
  inout   [ 3:0]  ddr_dm,
  inout   [31:0]  ddr_dq,
  inout   [ 3:0]  ddr_dqs_n,
  inout   [ 3:0]  ddr_dqs_p,
  inout           ddr_odt,
  inout           ddr_ras_n,
  inout           ddr_reset_n,
  inout           ddr_we_n,

  inout           fixed_io_ddr_vrn,
  inout           fixed_io_ddr_vrp,
  inout   [53:0]  fixed_io_mio,
  inout           fixed_io_ps_clk,
  inout           fixed_io_ps_porb,
  inout           fixed_io_ps_srstb,

  inout   [ 1:0]  btn,
  inout   [ 5:0]  led,

// 4. Add SPI ports for both ADC PMOD connector and sniffing PMOD connector 
  /*here*/
  /*here*/
  /*here*/
  /*here*/

  /*here*/
  /*here*/
  /*here*/
  /*here*/
);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
 
// 3. Declare the PWM wires that controls the LED's

  /*here*/
  /*here*/
  /*here*/
  
  /*here*/
  /*here*/
  /*here*/

  // instantiations
  ad_iobuf #(
    .DATA_WIDTH (2)
  ) i_iobuf_buttons (
    .dio_t (gpio_t[1:0]),
    .dio_i (gpio_o[1:0]),
    .dio_o (gpio_i[1:0]),
    .dio_p (btn));

  ad_iobuf #(
    .DATA_WIDTH (6)
  ) i_iobuf_leds (
    .dio_t (2'h0),
// 2. Connect the PWM wires to the input port of the ad_iobuf
    .dio_i ({/*here*/           //led[5]
             /*here*/           //led[4]
             /*here*/           //led[3]
             /*here*/           //led[2]
             /*here*/           //led[1]
             /*here*/}),        //led[0]
    .dio_o (gpio_i[7:2]),
    .dio_p (led));

  assign gpio_i[63:32] = gpio_o[63:32];
  assign gpio_i[31:8] = gpio_o[31:8];

// 6. Clone the ADC SPI port to the sniffing ports 

  /*here*/
  /*here*/
  /*here*/
  /*here*/

  system_wrapper i_system_wrapper (
    .ddr_addr (ddr_addr),
    .ddr_ba (ddr_ba),
    .ddr_cas_n (ddr_cas_n),
    .ddr_ck_n (ddr_ck_n),
    .ddr_ck_p (ddr_ck_p),
    .ddr_cke (ddr_cke),
    .ddr_cs_n (ddr_cs_n),
    .ddr_dm (ddr_dm),
    .ddr_dq (ddr_dq),
    .ddr_dqs_n (ddr_dqs_n),
    .ddr_dqs_p (ddr_dqs_p),
    .ddr_odt (ddr_odt),
    .ddr_ras_n (ddr_ras_n),
    .ddr_reset_n (ddr_reset_n),
    .ddr_we_n (ddr_we_n),

    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio (fixed_io_mio),
    .fixed_io_ps_clk (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb (fixed_io_ps_srstb),

    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),

    .spi0_clk_i (),
    .spi0_clk_o (/*here*/),   // 5. Connect here the SPI CLK
    .spi0_csn_0_o (/*here*/),   // 5. Connect here the SPI CS
    .spi0_csn_1_o (),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (/*here*/),   // 5. Connect here the SPI MISO
    .spi0_sdo_i (),
    .spi0_sdo_o (/*here*/),   // 5. Connect here the SPI MOSI
    .spi1_clk_i (1'b0),
    .spi1_clk_o (),
    .spi1_csn_0_o (),
    .spi1_csn_1_o (),
    .spi1_csn_2_o (),
    .spi1_csn_i (1'b1),
    .spi1_sdi_i (1'b0),
    .spi1_sdo_i (1'b0),
    .spi1_sdo_o (),
// 1. Declare the block design ports and connect them to the PWM wires 
    /*here*/
    /*here*/
    /*here*/
    /*here*/
    /*here*/
    /*here*/);

endmodule
