module control (
input clock,
input reset,
input start,
input straight, 
input right,
input left,
input oneframe, 
input [7:0] counterx, countery,
output reg draw_bg, 
output reg draw_car, 
output reg erase,
output reg plot,
)
reg [3:0] current_state, next_state;

localparam START_RACE = 4'd0, 
DRAW_BG = 4'd1,
DRAW_CAR = 4'd2,
WAIT_MOVE = 4'd3,
STRAIGHT = 4'd4,
LEFT = 4'd5,
RIGHT = 4'd6,
ERASE_CAR = 4'd7,
UPDATE_CAR = 4'd8;

always@ (*)
begin
    case (current_state)

    START_RACE: next_state = DRAW_BG;
    DRAW_BG:
    begin
        if (counterx == 8'd160)
            next_state = DRAW_CAR;
        else
            next_state = DRAW_BG;
    end
    DRAW_CAR:
    begin
        if (counterx == 8'd4)
            next_state = WAIT_MOVE;
        else
            next_state = DRAW_CAR;
    end
    WAIT_MOVE:
    begin
        if (straight) 
            next_state = STRAIGHT;
        else if (left)
            next_state = LEFT;
        else if (right)
            next_state = RIGHT;
        else
            next_state = WAIT_MOVE;
    end
    STRAIGHT: next_state = ERASE_CAR;

    LEFT: next_state = ERASE_CAR;

    RIGHT = next_state = ERASE_CAR_CAR;

    ERASE_CAR:
    begin
        if (counterx == 8'd160)
            next_state = UPDATE_CAR
    end
    UPDATE_CAR:
    begin
        if (counterx == 8'd4)
            next_state = WAIT_MOVE;
    end
    default: next_state = START_RACE;

    endcase
end

endmodule

always @(*)
begin 
    draw_bg = 1'b0; 
    draw_car = 1'b0; 
    resetsignal = 1'b0;
    erase = 1'b0;

case (current_state)
    DRAW_BG: 
    begin
        draw_bg = 1'b1;
        plot = 1'b1;

    end
    DRAW_CAR:
    begin
        draw_car = 1'b1;
        plot = 1'b1;
    end
    ERASE_CAR:
    begin
        erase = 1'b1;
        plot = 1'b1;
    end
endcase
end

always @(posedge clock)
begin
    if (reset)
        current_state <= SET_RESET_SIGNAL;
    else
        current_state <= next_state;
end

