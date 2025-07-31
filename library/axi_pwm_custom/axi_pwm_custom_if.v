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

  reg [11:0] pwm_counter = 12'd0;
  wire end_of_period;
  assign end_of_period = (pwm_counter == 12'd4095)? 1'b1 : 1'b0;

  // 1. Registri care salvează valorile DOAR după end_of_period
  reg [11:0] latched_0 = 12'd0;
  reg [11:0] latched_1 = 12'd0;
  reg [11:0] latched_2 = 12'd0;
  reg [11:0] latched_3 = 12'd0;
  reg [11:0] latched_4 = 12'd0;
  reg [11:0] latched_5 = 12'd0;

  always @(posedge pwm_clk ) begin
    if (!rstn) begin
      pwm_counter <= 12'd0;
    end else begin
      pwm_counter <= pwm_counter + 1'b1;
  end
end

  // 2. Latch noua valoare DOAR la final de perioadă
  always @(posedge pwm_clk) begin
    if (!rstn) begin
      latched_0 <= 12'd0;
      latched_1 <= 12'd0;
      latched_2 <= 12'd0;
      latched_3 <= 12'd0;
      latched_4 <= 12'd0;
      latched_5 <= 12'd0;
    end else if (end_of_period) begin
      latched_0 <= data_channel_0;
      latched_1 <= data_channel_1;
      latched_2 <= data_channel_2;
      latched_3 <= data_channel_3;
      latched_4 <= data_channel_4;
      latched_5 <= data_channel_5;
    end
  end

  // 3. Compară counterul cu valorile stabilizate
  assign pwm_led_0 = (pwm_counter < latched_0);
  assign pwm_led_1 = (pwm_counter < latched_1);
  assign pwm_led_2 = (pwm_counter < latched_2);
  assign pwm_led_3 = (pwm_counter < latched_3);
  assign pwm_led_4 = (pwm_counter < latched_4);
  assign pwm_led_5 = (pwm_counter < latched_5);

endmodule
