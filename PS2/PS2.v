module PS2 (CLOCK_50, KEY, ps2_clk, ps2_data, HEX0, HEX1, HEX2, HEX3)
    input CLOCK_50; //50 MHz clock
    input KEY;

    inout ps2_clk; //pin names for the ps2 clock and data
    inout ps2_data;

    output HEX0;
    output HEX1;
    output HEX2;
    output HEX3; // display of information on different hex displays 



endmodule

module controlpath (
    input clock,  
    input clr, 
    input ps2clock, //standard logic
    input ps2data, 

    output keyVal1 [7:0],
    output keyVal2 [7:0],
    output keyVal3 [7:0]
)

    localparam start = 4'd0,
    Wlow1 = 4'd1,
    Whi1 = 4'd2,
    getKey1 = 4'd3,
    Wlow2 = 4'd4,
    Whi2 = 4'd5,
    getKey2 = 4'd6,
    breakKey = 4'd7,
    Wlow3 = 4'd8,
    Whi3 = 4'd9,
    getKey3 = 4'd10;




endmodule 

module shiftregister (
    input CLOCK_50, 
    input clear,
    input ps2_data, 

    output reg [10:0] ps2D
    )
    reg [10:0] shift;

    always@ (posedge CLOCK_50)begin 
        if (clear == 1'b1) begin
            ps2D <= 10'b0;
        end

        else begin
            shift <= ps2D>>1;
            ps2D <= {ps2_data, shift [9:0]};
        end
    end 
endmodule 
