module PS2 (
	 input CLOCK_50,
    input PS2_CLK, //pin names for the ps2 clock and data
    input PS2_DAT,
	 input [9:0] SW, 
    output [6:0] HEX0,
	 output [6:0] HEX1,
   // display of information on different hex displays 
);

wire enable1, enable2, enable3;
wire [10:0] shift1, shift2, shift3;
wire [7:0] keyval1, keyval2, keyval3;
wire [3:0] current;
wire [3:0] bitcount;
//wire speedClk

controlpath control (SW[0], CLOCK_50, PS2_CLK, PS2_DAT, keyval1);
hex display (CLOCK_50, keyval1, HEX0, HEX1);

//ratediv ratediv (CLOCK_50, KEY[0], speedClk);
//HEX_display hex_display (speedClk, keyval1, keyval2, keyval3, KEY[0]);

endmodule 



module controlpath (
    input [9:0] SW,
    input CLOCK_50,
    input PS2_CLK, //standard logic
    input PS2_DAT, 

    output reg [7:0] keyval1,
);

    reg [3:0] next_state;


    localparam start = 4'd0,
    WaitLow1 = 4'd1,
    WaitHi1 = 4'd2,
    getKey1 = 4'd3,
    WaitLow2 = 4'd4,
    WaitHi2 = 4'd5,
    getKey2 = 4'd6,
    breakKey = 4'd7,
    WaitLow3 = 4'd8,
    WaitHi3 = 4'd9,
    getKey3 = 4'd10;

    always @(posedge CLOCK_50) begin
		if (SW[0] == 1'b1) begin //active high SW[0] is 1
			current_state = start;
            bitcount <= 4'b0;
            shift1 <= 11'b0;
            shift2 <= 11'b0;
            shift3 <= 11'b0;
            keyval1 <= 8'b0;
            keyval2 <= 8'b0;
            keyval3 <= 8'b0;
        end
		else begin
			current_state = next_state;
        end
	end


    always @(posedge CLOCK_50) begin
        case(current_state)
            start:
				begin
                bitcount <= 4'b0;
                if (PS2_DAT == 1) 
                    next_state = start;
				 
                else if (PS2_DAT == 0)
                    next_state = WaitLow1;
				end
            
            WaitLow1: 
				begin
                if (bitcount < 4'd11) begin
                    if (PS2_CLK == 1)
                        next_state = WaitLow1;
                    else begin
                        next_state = WaitHi1; 
                        shift1 <= {PS2_DAT, shift1[10:1]};
                    end

                end

                else if (bitcount == 4'd11)
                    next_state = getKey1;

				end

            WaitHi1:
				begin
                    next_state = WaitHi1;
                    if (PS2_CLK == 1'b1) begin
                        next_state = WaitLow1;
                        if (bitcount < 4'd11)
                            bitcount = bitcount + 1;
                    end
				end

            getKey1:
				begin
                keyval1 <= shift1[8:1];
                bitcount = 4'b0;
                next_state = WaitLow2;
				end
            
            WaitLow2:
				begin
                if (bitcount < 4'd11) begin
                    if (PS2_CLK == 1)
                        next_state = WaitLow2;
                    else begin
                        next_state = WaitHi2; 
                        shift2 <= {PS2_DAT, shift2[10:1]};
                    end

                end

                else if (bitcount == 4'd11)
                    next_state = getKey2;
				end

            
            WaitHi2:
				begin
                if (PS2_CLK == 1'b0)
                    next_state = WaitHi2;
                else begin
                    next_state = WaitLow2;
                    if (bitcount < 4'd11)
                        bitcount = bitcount + 1;
                end
                
				end

            getKey2:
				begin
                keyval2 <= shift2[8:1];
                bitcount<= 4'b0;
                next_state = WaitLow3;
            end

            breakKey: 
            begin
                if (keyval2 == 8'hF0)
                    next_state = WaitLow3;
                else begin
                    if (keyval2 == 8'hE0) 
                        next_state = WaitLow1;
                    else 
                        next_state = WaitLow2;
                end

            end
            
            WaitLow3:
				begin
                if (bitcount < 4'd11) begin
                    if (PS2_CLK == 1)
                        next_state = WaitLow3;
                    else begin
                        next_state = WaitHi3; 
                        shift3 <= {PS2_DAT, shift3[10:1]};
                    end

                end

                else if (bitcount == 4'd11)
                    next_state = getKey3;
				end
				
            WaitHi3: 
				begin

              if (PS2_CLK == 1'b0)
                    next_state = WaitHi3;
                else begin
                    next_state = WaitLow3;
                    if (bitcount < 4'd11)
                        bitcount = bitcount + 1;
                end
                
				end
            
            getKey3: 
				begin
                keyval3 <= shift3 [8:1];
                bitcount <= 4'b0;
                next_state = start;
				end
        
        endcase
    end


endmodule 

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
    assign HEX0 = {
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

    assign HEX1 = {
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
