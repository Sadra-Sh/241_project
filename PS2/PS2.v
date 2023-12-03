module PS2 (
    input CLOCK_50, //50 MHz clock
    input KEY,

    inout PS2_CLK, //pin names for the ps2 clock and data
    inout PS2_DAT,

    output HEX0,
    output HEX1,
    output HEX2,
    output HEX3 // display of information on different hex displays 
)

wire [7:0] keyval1, keyval2, keyval3;
//wire speedClk

controlpath parallelbits (CLOCK_50, KEY[0], PS2_CLK, PS2_DAT, keyval1, keyval2, keyval3);
hex hexdisplay (CLOCK_50, KEY[0], keyval1, keyval2, keyval3, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
//ratediv ratediv (CLOCK_50, KEY[0], speedClk);
//HEX_display hex_display (speedClk, keyval1, keyval2, keyval3, KEY[0]);



endmodule

module controlpath (
    input clock,  
    input clr, 
    input ps2Clk, //standard logic
    input ps2Data, 

    output keyVal1 [7:0],
    output keyVal2 [7:0],
    output keyVal3 [7:0]
)

    reg [3:0] current_state, next_state;
    reg [10:0] bitcount;
    reg [10:0] shiftRegister1, shiftRegister2, shiftRegister3; //3 shift registers to keep count of the make/break codes


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


    always @(*) begin
        case(current_state)
            start:
                if (ps2Data == 1)
                    next_state = start;
                else if (ps2Data) 
                    next_state = WaitLow1;
            
            WaitLow1: 
                if (bitcount < 11 && ps2Clk == 1)
                    next_state = WaitLow1;
                else if (ps2Clk == 0) begin
                    next_state = WaitHi1;
                    shiftRegister1 <= {PS2_DAT, shiftRegister1[10:1]} //concatinate the date coming in from ps2 with the last 
                    // 10 bits of the shiftRegister
                end
                else if (bitcount == 11)
                    next_state <= getKey1;

            WaitHi1:
                if (ps2Clk == 0) 
                    next_state <= WaitHi1;
                else begin
                    next_state <= WaitLow1;
                    bitcount <= bitcount + 1
                end

            getKey1:
                assign keyVal1 = shitRegister1 [8:1]; //2 MSB are stop an parity, LSB is start
                bitcount <= 11'b0;
                next_state <= WaitLow2;
            
            WaitLow2:
                 if (bitcount < 11 && ps2Clk == 1)
                    next_state = WaitLow2;
                else if (ps2Clk == 0) begin
                    next_state = WaitHi2;
                    shiftRegister2 <= {PS2_DAT, shiftRegister2[10:1]} //concatinate the date coming in from ps2 with the last 
                    // 10 bits of the shiftRegister
                end
                else if (bitcount == 11)
                    next_state <= getKey2;
            
            WaitHi2:    
                if (ps2Clk = 0) 
                    next_state <= WaitHi2;
                else if (ps2Clk = 1) begin
                    next_state <= WaitLow2;
                    bitcount <= bitcount + 1;
                end

            getKey2: 
                assign keyVal2 = shiftRegister2 [8:1];
                bitcount <= 11'b0;
                next_state <= breakKey;
            
            breakKey:
                if (keyVal2 == 2'hF0)
                    next_state <= WaitLow3;
                else begin  
                    if (keyVal2 == 2'hE0)
                        next_state <= WaitLow1;
                    else 
                        next_state <= waitLow2;
                end
            
            WaitLow3:
                 if (bitcount < 11 && ps2Clk == 1)
                    next_state = WaitLow3;
                else if (ps2Clk == 0) begin
                    next_state = WaitHi3;
                    shiftRegister3 <= {PS2_DAT, shiftRegister3[10:1]} //concatinate the date coming in from ps2 with the last 
                    // 10 bits of the shiftRegister
                end
                else if (bitcount == 11)
                    next_state <= getKey3;

            WaitHi3:    
                if (ps2Clk = 0)
                    next_state <= WaitHi3;
                else begin
                    bitcount <= bitcount + 1;
                    next_state <= WaitLow3;
                end
            
            getKey3: 
                assign keyVal3 = shiftRegister3 [8:1];
                bitcount <= 11'b0;
                next_state <= WaitLow1;
        
        endcase
    end

endmodule 

module hex (
    input clock,
    input reset, 
    input key1, 
    input key2,
    input key3, 

    output HEX0, 
    output HEX1, 
    output HEX2, 
    output HEX3, 
    output HEX4, 
    output HEX5
)




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


endmodule

module ratediv (
    input clock50, 
    input reset,

    output speedClk,
)
reg [$clog(50000000*4)-1 : 0] downcount;

always @(posedge clock50) begin
    if (reset || downcount == 28'd0) //if downcount reached zero, start over
        downcount <= (50000000 * 0.25) - 1;
    else 
        downcount <= downcount -1;
end

assign speedClk= (downcount == 0) ? 1'b1:1'b0; //pulse only when downcount is zero

endmodule  */ 
