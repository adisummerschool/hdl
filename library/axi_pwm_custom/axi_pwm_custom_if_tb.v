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

module axi_pwm_custom_if_tb;
  parameter VCD_FILE = "axi_pwm_custom_if_tb.vcd";

  `define TIMEOUT 200000
  `include "../common/tb/tb_base.v"

  // =========================================================================
  // Initialization: signals, parameters, DUT instantiation, clock generation
  // =========================================================================

  // DUT inputs
  reg           resetn_in        = 1'b0;
  reg           pwm_clk          = 1'b0;
  reg   [11:0]  data_channel_0   = 12'b0;
  reg   [11:0]  data_channel_1   = 12'b0;
  reg   [11:0]  data_channel_2   = 12'b0;
  reg   [11:0]  data_channel_3   = 12'b0;
  reg   [11:0]  data_channel_4   = 12'b0;
  reg   [11:0]  data_channel_5   = 12'b0;

  // testbench period counter, mirrors the DUT internal counter
  reg   [11:0]  pulse_period_cnt = 12'h0;
  parameter [11:0] pulse_period_d = 12'd4095;

  // flags end of a PWM period, used to sync drive_pwm and verify tasks
  reg           end_of_period    = 1'b0;

  reg [5:0] pre_trn_state;
  reg indicator [5:0];

  // DUT outputs
  wire          pwm_led_0;
  wire          pwm_led_1;
  wire          pwm_led_2;
  wire          pwm_led_3;
  wire          pwm_led_4;
  wire          pwm_led_5;

  // DUT instantiation
  axi_pwm_custom_if axi_pwm_custom_if_dut(
    .pwm_clk(pwm_clk),
    .rstn(resetn_in),
    .data_channel_0(data_channel_0),
    .data_channel_1(data_channel_1),
    .data_channel_2(data_channel_2),
    .data_channel_3(data_channel_3),
    .data_channel_4(data_channel_4),
    .data_channel_5(data_channel_5),
    .pwm_led_0(pwm_led_0),
    .pwm_led_1(pwm_led_1),
    .pwm_led_2(pwm_led_2),
    .pwm_led_3(pwm_led_3),
    .pwm_led_4(pwm_led_4),
    .pwm_led_5(pwm_led_5));

  initial begin
    pwm_clk <= 1'b0;
    forever begin
      #1 pwm_clk <= ~pwm_clk;
    end
  end

  // =========================================================================
  // Test sequence
  // =========================================================================

  initial begin
    // assume failure until all tests pass; tb_base.v reports based on this flag
    failed = 1'b1;
    // toggle clock during reset so the DUT can latch initial values
     clk_delay(.n(2));

    $display("--- [TEST 1/4] Reset test: verifying outputs stay stable while reset is active ---");
    fork
      begin
        clk_delay(.n(2));
        drive_pwm(.period_pwm(1));
      end
      begin
        verify_reset(.thr(12'd100));
      end
    join

    $display("--- [TEST 2/4] PWM output test: verifying transitions happen at the correct threshold ---");
    fork
      begin
        clk_delay(.n(2));
        drive_pwm(.period_pwm(5));
      end
      begin
        verify_pwm_output(.thr0(12'd100), .thr1(12'd200), .thr2(12'd300), .thr3(12'd400), .thr4(12'd500), .thr5(12'd600), .round(5));
      end
    join

    $display("--- [TEST 3/4] Shadow register test: verifying mid-period threshold changes are deferred ---");
    fork
      begin
        clk_delay(.n(2));
        drive_pwm(.period_pwm(1));
      end
      begin
        verify_load(.thr0(12'd4000), .switch_value(12'd50), .thr1(12'd30));
      end
    join

    $display("--- [TEST 4/4] PWM value test: verifying pre/post-transition output levels ---");
    fork
      begin
        clk_delay(.n(2));
        drive_pwm(.period_pwm(1));
      end
      begin
        verify_pwm_value(.pre_trn_values(6'b111111), .thr(12'd100), .post_trn_values(6'b000000));
      end
    join


    $display("=== ALL 4 TESTS PASSED ===");
    failed = 1'b0;
    $finish();
  end

  // =========================================================================
  // Task implementations
  // =========================================================================

  // Verifies that all PWM channels transition at the correct threshold.
  // For each round: when threshold is 0, checks all outputs flip using XOR;
  // otherwise samples each channel at threshold-1 and verifies transition at threshold+1.
  // After each period, increments thresholds by thr0..thr5.
  task verify_pwm_output(
    input [11:0] thr0,
    input [11:0] thr1,
    input [11:0] thr2,
    input [11:0] thr3,
    input [11:0] thr4,
    input [11:0] thr5,
    input integer round);
    reg [5:0] initial_state;
    reg [5:0] current_state;
    reg [5:0] xor_result;
    integer i;
  begin
    initial_state = {pwm_led_5, pwm_led_4, pwm_led_3, pwm_led_2, pwm_led_1, pwm_led_0};
    data_channel_0 <= 12'b0;
    data_channel_1 <= 12'b0;
    data_channel_2 <= 12'b0;
    data_channel_3 <= 12'b0;
    data_channel_4 <= 12'b0;
    data_channel_5 <= 12'b0;
    @(posedge pwm_clk);
    resetn_in <= 1'b1;
    @(posedge pwm_clk);
    for (i = 0; i < round; i = i + 1) begin
      indicator[0]=1; indicator[1]=1; indicator[2]=1;
      indicator[3]=1; indicator[4]=1; indicator[5]=1;
      wait(!end_of_period);
      while(!end_of_period) begin
        @(negedge pwm_clk);
        if(data_channel_0 == 12'b0) begin
          if(pulse_period_cnt == 0) begin
            current_state = {pwm_led_5, pwm_led_4, pwm_led_3, pwm_led_2, pwm_led_1, pwm_led_0};
            xor_result = initial_state ^ current_state;
            if(!(&xor_result)) begin
              $display("FAIL: Threshold 0 but not all channels transitioned at count 0, round %0d", i);
              $finish();
            end
          end
        end else begin
          check_channel(0, data_channel_0, pwm_led_0, i);
          check_channel(1, data_channel_1, pwm_led_1, i);
          check_channel(2, data_channel_2, pwm_led_2, i);
          check_channel(3, data_channel_3, pwm_led_3, i);
          check_channel(4, data_channel_4, pwm_led_4, i);
          check_channel(5, data_channel_5, pwm_led_5, i);
        end
        if (pulse_period_cnt == pulse_period_d - 1) begin
          data_channel_0 <= data_channel_0 + thr0;
          data_channel_1 <= data_channel_1 + thr1;
          data_channel_2 <= data_channel_2 + thr2;
          data_channel_3 <= data_channel_3 + thr3;
          data_channel_4 <= data_channel_4 + thr4;
          data_channel_5 <= data_channel_5 + thr5;
        end
      end
    end

    $display("PASSED");
    resetn_in <= 1'b0;
    //clk_delay(.n(1));
  end
  endtask

  task check_channel(
    input integer ch,
    input [11:0] thr,
    input pwm_led,
    input integer round);
  begin
    if (pulse_period_cnt == thr - indicator[ch]) begin
      if(indicator[ch]) begin
        pre_trn_state[ch] = pwm_led;
        indicator[ch] = 0;
      end else begin
        if(pwm_led == pre_trn_state[ch]) begin
          $display("FAIL: Channel %0d did not transition at threshold %0d (counter=%0d), round %0d. Output stuck at %b", ch, thr, pulse_period_cnt, round, pwm_led);
          $finish();
        end
      end
    end
  end
  endtask

  // Drives pwm_clk, pulse_period_cnt, and end_of_period for a given number
  // of PWM periods. Each period is pulse_period_d+1 clock cycles (0 to 4095).
  // An extra clock edge at the end lets concurrent tasks see end_of_period=1.
  task drive_pwm(input integer period_pwm);
    integer i;
    integer j;
  begin
    end_of_period = 1'b0;
    for (j = 0; j < period_pwm; j = j + 1) begin
      pulse_period_cnt = 12'h0;
      for (i = 0; i <= pulse_period_d; i = i + 1) begin
        @(posedge pwm_clk);
        pulse_period_cnt = pulse_period_cnt + 1;
        if(pulse_period_cnt == pulse_period_d) begin
          end_of_period = 1'b1;
        end else begin
          end_of_period = 1'b0;
        end
        @(negedge pwm_clk);
      end
    end
    @(posedge pwm_clk);
    end_of_period = 1'b0;
    @(negedge pwm_clk);
  end
  endtask

  // Toggles pwm_clk for n cycles without updating counters or flags.
  // Used to provide clock edges during reset before tests begin.
  task clk_delay(input integer n);
    integer k;
    for (k = 0; k < n; k = k + 1) begin
      @(posedge pwm_clk);
      @(negedge pwm_clk);
    end
  endtask

  // Verifies that during reset all PWM outputs stay stable.
  // Loads a non-zero threshold on all channels and checks none change
  // for the entire period while reset is asserted.
  task verify_reset(input [11:0] thr);
    reg [5:0] initial_state;
    reg [5:0] current_state;
  begin
    data_channel_0 <= thr;
    data_channel_1 <= thr;
    data_channel_2 <= thr;
    data_channel_3 <= thr;
    data_channel_4 <= thr;
    data_channel_5 <= thr;
    @(posedge pwm_clk);
    resetn_in <= 1'b1;
    @(posedge pwm_clk);
    resetn_in <= 1'b0;
    initial_state = {pwm_led_5, pwm_led_4, pwm_led_3, pwm_led_2, pwm_led_1, pwm_led_0};
    if (^initial_state === 1'bx) begin
      $display("FAIL: DUT outputs are uninitialized");
      $finish();
    end
    while(!end_of_period) begin
      @(posedge pwm_clk);
      current_state = {pwm_led_5, pwm_led_4, pwm_led_3, pwm_led_2, pwm_led_1, pwm_led_0};
      if(current_state != initial_state) begin
        $display("FAIL: Outputs changed during reset (tip: check reset polarity) ", initial_state, current_state);
        $finish();
      end
    end

    $display("PASSED");
  end
  endtask

  task verify_load(
    input [11:0] thr0,
    input [11:0] switch_value,
    input [11:0] thr1);
    reg [5:0] pre_state;
    reg [5:0] current_state;
    reg [5:0] xor_result;
  begin
    data_channel_0 <= thr0;
    data_channel_1 <= thr0;
    data_channel_2 <= thr0;
    data_channel_3 <= thr0;
    data_channel_4 <= thr0;
    data_channel_5 <= thr0;
    @(posedge pwm_clk);
    resetn_in <= 1'b1;
    @(posedge pwm_clk);
    wait(!end_of_period);
    while(!end_of_period) begin
      @(negedge pwm_clk);
      if(pulse_period_cnt == switch_value) begin
        data_channel_0 <= thr1;
        data_channel_1 <= thr1;
        data_channel_2 <= thr1;
        data_channel_3 <= thr1;
        data_channel_4 <= thr1;
        data_channel_5 <= thr1;
      end
      if(pulse_period_cnt == thr0 - 1) begin
        pre_state = {pwm_led_5, pwm_led_4, pwm_led_3, pwm_led_2, pwm_led_1, pwm_led_0};
      end
      if(pulse_period_cnt == thr0) begin
        current_state = {pwm_led_5, pwm_led_4, pwm_led_3, pwm_led_2, pwm_led_1, pwm_led_0};
        xor_result = pre_state ^ current_state;
        if(&xor_result) begin
          $display("PASSED");
        end else begin
          $display("FAIL: Load test failed (tip: check that inputs are registered, not used directly)");
          $finish();
        end
      end
    end
    resetn_in <= 1'b0;
  end
  endtask

  task verify_pwm_value(
    input [5:0]  pre_trn_values,
    input [11:0] thr,
    input [5:0]  post_trn_values);
    reg [5:0] pre_state;
    reg [5:0] current_state;
  begin
    data_channel_0 <= thr;
    data_channel_1 <= thr;
    data_channel_2 <= thr;
    data_channel_3 <= thr;
    data_channel_4 <= thr;
    data_channel_5 <= thr;
    @(posedge pwm_clk);
    resetn_in <= 1'b1;
    @(posedge pwm_clk);
    wait(!end_of_period);
    while(!end_of_period) begin
      @(negedge pwm_clk);
      if(pulse_period_cnt == thr - 1) begin
        pre_state = {pwm_led_5, pwm_led_4, pwm_led_3, pwm_led_2, pwm_led_1, pwm_led_0};
        if(pre_state != pre_trn_values) begin
          $display("FAIL: Pre-transition values mismatch (expected %b, got %b)", pre_trn_values, pre_state);
          $finish();
        end
      end
      if(pulse_period_cnt == thr) begin
        current_state = {pwm_led_5, pwm_led_4, pwm_led_3, pwm_led_2, pwm_led_1, pwm_led_0};
        if (current_state != post_trn_values) begin
          $display("FAIL: Post-transition values mismatch (expected %b, got %b)", post_trn_values, current_state);
          $finish();
        end
      end
    end
    $display("PASSED");
    resetn_in <= 1'b0;
  end
  endtask

endmodule