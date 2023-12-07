module PS2 (
	 input CLOCK_50,
    input PS2_CLK, //pin names for the ps2 clock and data
    input PS2_DAT,
	 input [9:0] SW, 
    output [3:0] bitcount,
    output [3:0] current_state

   // display of information on different hex displays 
);

wire [7:0] keyval1;
wire reset, keyenable;

//wire speedClk
controlpath control (SW[0], CLOCK_50, PS2_CLK, PS2_DAT, keyval1, keyenable, reset, current_state, wpress, apress, spress, dpress);
Datapath datapath (SW[0], PS2_CLK, PS2_DAT, reset, keyenable, keyval1, bitcount);

//ratediv ratediv (CLOCK_50, KEY[0], speedClk);
//HEX_display hex_display (speedClk, keyval1, keyval2, keyval3, KEY[0]);

endmodule



module controlpath (
    input clear,
    input clock50,
    input ps2Clk, //standard logic
    input ps2Data, 
    input [7:0] keyval1,
    

    output reg key_enable,
    output reg reset_enable,
    output reg [3:0] current_state,

    output reg w_pressed, 
    output reg a_pressed,
    output reg s_pressed,
    output reg d_pressed
);

    reg [3:0] next_state;

    localparam
    start = 3'd0,
    IDLE = 3'd1,
    bitAssessment = 3'd2,
    keyPressed = 3'd3;

    reg breakCode;

    always @(posedge clock50) begin
		if (clear == 1'b1)  //active high SW[0] is 1
			current_state = start;
        
		else 
			current_state = next_state;
        
	end

    always @(posedge clock50) begin
        case(current_state)
        start: 
        begin
            if (ps2Clk == 1)    
                next_state = start;

            else if (ps2Clk == 0)
                next_state = IDLE;
        end

        IDLE:
        begin
            if (ps2Data == 1)begin
                next_state = IDLE;
            end
            else if (ps2Data == 0) begin
                next_state = bitAssessment;
            end
        end

        bitAssessment: 
        begin
            if (keyval1 == 8'hF0) begin
                next_state = bitAssessment;
            end
            else begin
                next_state = keyPressed;
            end
        end

        keyPressed:
        begin
            if (clear == 1'b1)
                next_state = clear;
            else 
                next_state = start;
        end

        clear: 
        begin
            next_state = start;
        end

        endcase

    end


    always @(posedge clock50) begin
        breakCode = 0;
        w_pressed <= 0;
        a_pressed <= 0;
        s_pressed <= 0;
        d_pressed <= 0;
        key_enable <= 0;
        reset_enable <= 0;

        case(current_state)

        IDLE:
        begin   
            if (ps2Data == 1)begin
                key_enable = 0;
            end
            else if (ps2Data == 0) begin
                key_enable = 1;
            end
        end

        bitAssessment: 
        begin
            if (keyval1 == 8'hF0) begin
                breakCode = 1;
                w_pressed <= 0;
                a_pressed <= 0;
                s_pressed <= 0;
                d_pressed <= 0;
            end
            else if (keyval1 != 8'hF0) begin
                breakCode = 0;
            end
        end

        keyPressed:
        begin
            if (keyval1 == 8'h1C)
                a_pressed = 1;
            else if (keyval1 == 8'h1D)
                w_pressed = 1;
            else if (keyval1 == 8'h1B)
                s_pressed = 1;
            else if (keyval1 == 8'h23)
                d_pressed = 1;

        end


        clear:
        begin
            reset_enable = 1;
            breakCode = 0;
            w_pressed <= 0;
            a_pressed <= 0;
            s_pressed <= 0;
            d_pressed <= 0;
        end

        endcase
    end


endmodule

module Datapath (
    input ps2Clk,
	input ps2Data,

	input reset_enable, 
	input key_enable, 
	
	output reg [7:0] keyval1,
    output reg [4:0] bitcount

    );

    reg [10:0] shift1;


	always @(negedge ps2Clk) begin
        if (reset_enable == 1'b1) begin
            bitcount <= 4'b0;
            shift1 <= 11'b0;
            keyval1 <= 8'b0;
        end 
        
        else begin

            if (key_enable == 1'b1) begin
                bitcount <= bitcount + 1;
            end 

            if (bitcount > 0 && bitcount < 11'd11) begin
                shift1 = {ps2Data, shift1[10:1]};
                bitcount <= bitcount + 1;
            end
            else if (bitcount == 4'd11) begin
                bitcount <= 4'b0;
                keyval1 <= shift1 [8:1];
            end
        end
    end
	

endmodule
