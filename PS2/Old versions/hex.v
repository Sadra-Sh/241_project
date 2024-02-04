module HexDisplay(
    input CLOCK_50,
    input [7:0] keyval,
    output [6:0] HEX0,
    output [6:0] HEX1
);

    reg [6:0] hex_value0;
    reg [6:0] hex_value1;

    always @(posedge CLOCK_50) begin
        // Convert the middle 8 bits of the make code to HEX for HEX0
        hex_value0 = keyval[7:4];

        // Convert the least significant 4 bits of the make code to HEX for HEX1
        hex_value1 = keyval[3:0];
    end

    // HEX decoder for common cathode 7-segment display
    assign HEX0 = ~{
        (hex_value0 == 4'h0) ? 7'b1000000 :
        (hex_value0 == 4'h1) ? 7'b1111001 :
        (hex_value0 == 4'h2) ? 7'b0100100 :
        (hex_value0 == 4'h3) ? 7'b0110000 :
        (hex_value0 == 4'h4) ? 7'b0011001 :
        (hex_value0 == 4'h5) ? 7'b0010010 :
        (hex_value0 == 4'h6) ? 7'b0000010 :
        (hex_value0 == 4'h7) ? 7'b1111000 :
        (hex_value0 == 4'h8) ? 7'b0000000 :
        (hex_value0 == 4'h9) ? 7'b0011000 :
        (hex_value0 == 4'hA) ? 7'b0001000 :
        (hex_value0 == 4'hB) ? 7'b0000011 :
        (hex_value0 == 4'hC) ? 7'b1000110 :
        (hex_value0 == 4'hD) ? 7'b0100001 :
        (hex_value0 == 4'hE) ? 7'b0000110 :
        (hex_value0 == 4'hF) ? 7'b0001110 : 7'b0000000
    };

    assign HEX1 = ~{
        (hex_value1 == 4'h0) ? 7'b1000000 :
        (hex_value1 == 4'h1) ? 7'b1111001 :
        (hex_value1 == 4'h2) ? 7'b0100100 :
        (hex_value1 == 4'h3) ? 7'b0110000 :
        (hex_value1 == 4'h4) ? 7'b0011001 :
        (hex_value1 == 4'h5) ? 7'b0010010 :
        (hex_value1 == 4'h6) ? 7'b0000010 :
        (hex_value1 == 4'h7) ? 7'b1111000 :
        (hex_value1 == 4'h8) ? 7'b0000000 :
        (hex_value1 == 4'h9) ? 7'b0011000 :
        (hex_value1 == 4'hA) ? 7'b0001000 :
        (hex_value1 == 4'hB) ? 7'b0000011 :
        (hex_value1 == 4'hC) ? 7'b1000110 :
        (hex_value1 == 4'hD) ? 7'b0100001 :
        (hex_value1 == 4'hE) ? 7'b0000110 :
        (hex_value1 == 4'hF) ? 7'b0001110 : 7'b0000000
    };

endmodule
