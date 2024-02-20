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
wire [3:0] current;
wire [3:0] bitcount;

//wire speedClk

controlpath control (SW[0], CLOCK_50, PS2_DAT, PS2_CLK, enable1, enable2, enable3, current, bitcount);
Datapath datapath (SW[0], PS2_CLK, PS2_DAT, enable1, enable2, enable3, keyval1, keyval2, keyval3, shift1, shift2, shift3);
HexDisplay u0 (CLOCK_50, keyval1, HEX0, HEX1);
//ratediv ratediv (CLOCK_50, KEY[0], speedClk);
//HEX_display hex_display (speedClk, keyval1, keyval2, keyval3, KEY[0]);

endmodule



module controlpath (
    input clear,
    input clock50, //standard logic
    input ps2Data, 
    input ps2Clk,

    output reg enable1,
    output reg enable2,
    output reg enable3,
    output reg [3:0] current_state,
    output reg [3:0] bitcount
);

    reg [3:0] next_state;
    


    localparam start = 4'd0,
    WaitLow1 = 4'd1,
    WaitHi1 = 4'd2,
    getKey1 = 4'd3,
    WaitLow2 = 4'd4,
    WaitHi2 = 4'd5,
    getKey2 = 4'd6,
    WaitLow3 = 4'd7,
    WaitHi3 = 4'd8,
    getKey3 = 4'd9;


    always @(posedge clock50) begin
		if (clear == 1'b1) begin //active high SW[0] is 1
			current_state <= start;
        end
		else begin
			current_state <= next_state;
        end
	end
    
    always @(*) begin
        case(current_state)
            start:
				begin

                bitcount <= 4'b0;
                enable1 <= 1'b0;
                enable2 <= 1'b0;
                enable3 <= 1'b0;

                if (ps2Data == 1) begin
                    next_state = start;

					end 
                else if (ps2Data == 0)
                    next_state = WaitLow1;
				end
            
            WaitLow1: 
				begin
                if (bitcount < 4'd11) begin
                    if (ps2Clk == 1) 
                        next_state = WaitLow1;
                    else begin
                        next_state = WaitHi1; 
                        enable1 <= 1;
                    end
                end
      
                else if (bitcount == 4'd11) begin
                    next_state = getKey1;
                end 
				end


            WaitHi1:
				begin
                next_state = WaitHi1;
                if (ps2Clk == 1'b1) begin
                    next_state = WaitLow1;
                    if (bitcount < 4'd11) begin
                        bitcount = bitcount + 1;
                    end
                end
                
				end

            getKey1:
				begin
                bitcount = 4'b0;
                enable1 = 1'b1;
                next_state = WaitLow2;
				end
            
            WaitLow2:
				begin
                if (bitcount < 4'd11) begin
                    if (ps2Clk == 1) 
                        next_state = WaitLow2;
                    else begin
                        next_state = WaitHi2; 
                        enable2 <= 1;
                    end
                end
      
                else if (bitcount == 4'd11) begin
                    next_state = getKey2;
                end 
				end
            
            WaitHi2:
				begin

                next_state = WaitHi2;
                if (ps2Clk == 1'b1) begin
                    next_state = WaitLow2;
                    if (bitcount < 4'd11) begin
                        bitcount = bitcount + 1;
                    end
                end

				end

            getKey2:
				begin
                enable2 = 1'b1;
                bitcount = 4'b0;
                next_state = WaitLow3;
            end
            
            WaitLow3:
				begin
                if (bitcount < 4'd11) begin
                    if (ps2Clk == 1) 
                        next_state = WaitLow3;
                    else begin
                        next_state = WaitHi3; 
                        enable3 <= 1;
                    end
                end
      
                else if (bitcount == 4'd11) begin
                    next_state = getKey3;
                end 
				end
				
            WaitHi3: 
				begin
                next_state = WaitHi3;
                if (ps2Clk == 1'b1) begin
                    next_state = WaitLow3;
                    if (bitcount < 4'd11) begin
                        bitcount = bitcount + 1;
                    end
                end
                
				end
            
            getKey3: 
				begin
                enable3 = 1'b1;
                next_state = start;
				end
        
        endcase
    end


endmodule 

module Datapath (

	input reset,
	input ps2Clk,
	input ps2Data,
	input enable1, 
	input enable2, 
	input enable3,
	
	output [7:0] keyval1,
	output [7:0] keyval2,
	output [7:0] keyval3,
    output reg [10:0] shift1,
	output reg [10:0] shift2,
	output reg [10:0] shift3
    );

	reg [10:0] ps2data;

	always @(negedge ps2Clk) begin	
		ps2data <= ps2Data;
		if (reset == 1'b1) begin
			shift1 <= 11'b0;
			shift2 <= 11'b0;
			shift3 <= 11'b0;
			
		end
		
		if (enable1 == 1'b1) begin
			shift1 <= {ps2data, shift1[10:1]};
		end 
		
		else if (enable2 == 1'b1) begin 
			shift2 <= {ps2data, shift2[9:0]};
		end
		
		else if (enable3 == 1'b1) begin
			shift3 <= {ps2data, shift3[9:0]};
		end
		
	
	end
	
	assign keyval1 = shift1 [8:1];
	assign keyval2 = shift2 [8:1];
	assign keyval3 = shift3 [8:1];

endmodule

module hex (

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

 


/* module HEX_display (
    input speedClk,
    input [7:0] key1,
    input [7:0] key2,
    input [7:0] key3,
    input reset,

    output HEX0, HEX1, //for displaying speed
    output HEX2//for displaying the gear
)
reg [6:0] speedcounter;
reg [1:0] gear;

always @(posedge speedClk) begin
    if (key1 == 2'h1D) begin
        speedcounter <= speedcounter + 1;
        if (speedcounter )
    end


end


endmodule */ 