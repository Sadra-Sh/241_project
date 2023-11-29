module control (
input clock,
input reset,
input start,
input straight, 
input right,
input left,
input oneframe, 
input done_bg,
input done_car, 
input done_race,
input done_erase
output reg start_race, 
output reg draw_bg, 
output reg draw_car, 
output reg drive,
output reg resetsignal,
output reg clear
)
reg [3:0] current_state, next_state;

localparam 
START_RACE = 4'd0,
DRAW_BG = 4'd1,
DRAW_CAR = 4'd2,
WAIT_MOVE = 4'd3,
STRAIGHT = 4'd4,
LEFT = 4'd5,
WAIT_LEFT = 4'd6,
RIGHT = 4'd7,
WAIT_RIGHT = 4'd8,
ERASE_CAR = 4'd9,
SET_RESET_SIGNAL = 4'd10;

always@ (*)
begin
    case (current_state)

    START_RACE: next_state = DRAW_BG;
    DRAW_BG: next_state = done_bg ? DRAW_CAR : DRAW_BG;
    DRAW_CAR:
    begin
        if (done_car)
        begin
            if (!start) next_state = SET_RESET_SIGNAL;
            else if (straight == 1'b1 && oneframe) next_state = ERASE_CAR;
            else if (left == 1'b1) next_state = WAIT_LEFT;
            else if (right == 1'b1) next_state = WAIT_RIGHT;
            else next_state = WAIT_MOVE;
        end
        else next_state = DRAW_CAR;
    end
    WAIT_MOVE:
    begin
        if (forward == 1'b1 && oneframe) next_state = ERASE_CAR;
        else if (left == 1'b1 || right == 1'b1) next_state = ERASE_CAR;
        else next_state = WAIT_MOVE;
    end
    STRAIGHT: next_state = DRAW_CAR;

    LEFT: next_state = DRAW_CAR;

    WAIT_LEFT: next_state = left ? WAIT_LEFT : WAIT_MOVE;

    RIGHT = next_state = DRAW_CAR;

    WAIT_RIGHT = next_state = right ? WAIT_RIGHT : WAIT_MOVE;

    ERASE_CAR:
    begin
        if (done_erase)
        begin
            if (forward == 1'b1) next_state = STRAIGHT;
            else if (left == 1'b1) next_state = LEFT;
            else if (right == 1'b1) next_state = RIGHT;
            else next_state = DRAW_CAR;
        end
        else next_state = ERASE_CAR;
    end
    SET_RESET_SIGNAL: next_state = draw_menu;

    endcase
end

endmodule

always @(*)
begin
    start_race = 1'b0; 
    draw_bg = 1'b0; 
    draw_car = 1'b0; 
    drive = 1'b0;
    resetsignal = 1'b0;
    clear = 1'b0;

case (current_state)
    DRAW_BG: 
    begin
        draw_bg = 1'b1;
    end
    DRAW_CAR:
    begin
        if (done_car)
            draw_car = 1'b0;
        else
            draw_car = 1'b1;
    end
    ERASE_CAR:
    begin
        if (clear)
    end
    SET_RESET_SIGNAL = resetsignal = 1'b1;
endcase
end

always @(posedge clock)
begin
    if (reset)
        current_state <= SET_RESET_SIGNAL;
    else
        current_state <= next_state;
end

