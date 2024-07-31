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

  //ADC PMOD connector 
  inout spi_adc_clk,
  inout spi_adc_cs,
  input spi_adc_sdi,
  inout spi_adc_sdo,

  //sniffing PMOD connector 
  inout spi_pmod_clk,
  inout spi_pmod_cs,
  output spi_pmod_sdi,
  inout spi_pmod_sdo
);

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
 
// 3. Declare the PWM wires that controls the LED's

  wire pwm_led_0_rw;
  wire pwm_led_0_gw;
  wire pwm_led_0_bw;

  wire pwm_led_1_rw;
  wire pwm_led_1_gw;
  wire pwm_led_1_bw;


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
    .dio_i ({pwm_led_1_gw,           //led[5]
             pwm_led_1_rw,           //led[4]
             pwm_led_1_bw,           //led[3]
             pwm_led_0_gw,           //led[2]
             pwm_led_0_rw,           //led[1]
             pwm_led_0_bw}),         //led[0]
    .dio_o (gpio_i[7:2]),
    .dio_p (led));

  assign gpio_i[63:32] = gpio_o[63:32];
  assign gpio_i[31:8] = gpio_o[31:8];

// 6. Clone the ADC SPI port to the sniffing ports 

  assign spi_pmod_clk = spi_adc_clk;
  assign spi_pmod_cs = spi_adc_cs;
  assign spi_pmod_sdi = spi_adc_sdi;
  assign spi_pmod_sdo = spi_adc_sdo;

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
    .spi0_clk_o (spi_adc_clk),   // 5. Connect here the SPI CLK
    .spi0_csn_0_o (spi_adc_cs),   // 5. Connect here the SPI CS
    .spi0_csn_1_o (),
    .spi0_csn_2_o (),
    .spi0_csn_i (1'b1),
    .spi0_sdi_i (spi_adc_sdi),   // 5. Connect here the SPI MISO
    .spi0_sdo_i (),
    .spi0_sdo_o (spi_adc_sdo),   // 5. Connect here the SPI MOSI
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
    .pwm_led_0_r(pwm_led_0_rw),
    .pwm_led_0_g(pwm_led_0_gw),
    .pwm_led_0_b(pwm_led_0_bw),
    .pwm_led_1_r(pwm_led_1_rw),
    .pwm_led_1_g(pwm_led_1_gw),
    .pwm_led_1_b(pwm_led_1_bw));

endmodule
