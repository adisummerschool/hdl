`timescale 1ns/100ps

module triangle_wave_generator (
    input               ref_clk,
    input               rstn,
    output reg [11:0]   triangle_wave
);

    reg direction; 

    always @(posedge ref_clk) begin
        if (~rstn) begin
            triangle_wave <=12'h000;
            direction <= 1'b1;
        end else begin
            if (direction == 1'b1) begin
                if (triangle_wave == 12'hFFF) begin
                    direction<= 1'b0;
                    triangle_wave <= triangle_wave - 1;
                end else begin
                    triangle_wave <= triangle_wave + 1;
                end
            end else begin
                if (triangle_wave == 12'h000) begin
                    direction<= 1'b1;
                    triangle_wave <= triangle_wave + 1;
                end else begin
                    triangle_wave <= triangle_wave - 1;
                end
            end
        end
    end

endmodule