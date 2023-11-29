module control (
input clock,
input reset,
input start,
input straight, 
input right,
input left,
input oneframe, 
input [7:0] counterx, countery,
output reg draw_bg_black,
output reg draw_bg_green_left,
output reg draw_bg_green_right, 
output reg draw_car, update_car 
output reg erase, inc
)
reg [3:0] current_state, next_state;

localparam START_RACE = 4'd0, 
DRAW_BG_BLACK = 4'd1,
DRAW_BG_GREEN_LEFT = 4'd2,
DRAW_BG_GREEN_RIGHT = 4'd3
DRAW_CAR = 4'd4,
WAIT_MOVE = 4'd5,
STRAIGHT = 4'd6,
LEFT = 4'd7,
RIGHT = 4'd8,
ERASE_CAR = 4'd9,
UPDATE_CAR = 4'd10;

always@ (*)
begin
    case (current_state)

    START_RACE: next_state = start ? DRAW_BG_GREEN_LEFT : START_RACE;
    DRAW_BG_GREEN_LEFT:
    begin
        if (countery == 8'd120)
            next_state = DRAW_BG_BLACK;
        else 
            next_state = DRAW_BG_GREEN_LEFT;
    end
    DRAW_BG_BLACK:
    begin
        if (countery == 8'd120)
            next_state = DRAW_BG_GREEN_RIGHT;
        else
            next_state = DRAW_BG_BLACK;
    end

    DRAW_BG_GREEN_RIGHT:
    begin
        if (countery == 8'd120)
            next_state = DRAW_CAR;
        else
            next_state = DRAW_BG_GREEN_RIGHT;
    end
    DRAW_CAR:
    begin
        if (countery == 8'd12)
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
        if (counterغ == 8'd120)
            next_state = UPDATE_CAR
    end
    UPDATE_CAR:
    begin
        if (counterغ == 8'd12)
            next_state = WAIT_MOVE;
    end
    default: next_state = START_RACE;

    endcase
end

endmodule

always @(*)
begin 
    draw_bg_black = 1'b0; 
    draw_bg_green_left = 1'b0;
    draw_bg_green_right = 1'b0;
    draw_car = 1'b0; 
    erase = 1'b0;
    inc = 1'b0;

case (current_state)
    DRAW_BG_BLACK: 
    begin
        draw_bg_black = 1'b1;
        if (counterx == 8'd100)
            inc = 1'b1;
    end
    DRAW_BG_GREEN_LEFT:
    begin
        draw_bg_green_left = 1'b1;
        if (counterx == 8'd30)
            inc = 1'b1;
    end
    DRAW_BG_GREEN_RIGHT:
    begin
        draw_bg_green_right = 1'b1;
        if (counterx == 8'd30)
            inc = 1'b1;
    end
    DRAW_CAR:
    begin
        draw_car = 1'b1;
        if (counterx == 8'd4)
            inc = 1'b1;
    end
    ERASE_CAR:
    begin
        erase = 1'b1;
        if (counterx == 8'd100)
            inc = 1'b1;
    end
    UPDATE_CAR:
    begin
        update_car = 1'b1;
        if (counterx == 8'd4)
            inc = 1'b1;
    end
    default: next_state = START_RACE;
endcase
end

always @(posedge clock)
begin
    if (reset)
        current_state <= START_RACE;
    else
        current_state <= next_state;
end

