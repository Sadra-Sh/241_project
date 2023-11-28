module control (
input clock,
input reset,
input start,
input straight, 
input right,
input left,
input oneframe, 
input done_menu,
input done_bg,
input done_car,
input done_win, 
input done_race,
input done_clear
output reg start_race, 
output reg draw_bg, 
output reg draw_car, 
output reg draw_win,  
output reg draw_menu, 
output reg drive,
output reg resetsignal,
output reg clear
)
reg [3:0] current_state, next_state;

localparam DRAW_MENU = 4'd0,
START_RACE = 4'd1,
DRAW_BG = 4'd2,
DRAW_CAR = 4'd3,
WAIT_MOVE = 4'd4,
STRAIGHT = 4'd5,
LEFT = 4'd6,
WAIT_LEFT = 4'd7,
RIGHT = 4'd8,
WAIT_RIGHT = 4'd9,
DRAW_WIN = 4'10,
MOVE_CAR = 4'd11,
SET_RESET_SIGNAL = 4'd12;

always@ (*)
begin
    case (current_state)

    DRAW_MENU:
    begin
        if (done_menu)
        begin
            if (done_race) next_state = DRAW_MENU;
            else if (start) next_state = START_RACE;
            else next_state = DRAW_MENU;
        end
        else next_state = DRAW_MENU;
    end
    START_RACE: next_state = DRAW_BG;
    DRAW_BG: next_state = done_bg ? DRAW_CAR : DRAW_BG;
    DRAW_CAR:
    begin
        if (done_car)
        begin
            if (!start) next_state = SET_RESET_SIGNAL;
            else if (done_race) next_state = DRAW_WIN;
            else if (straight == 1'b1 && oneframe) next_state = MOVE_CAR;
            else if (left == 1'b1) next_state = WAIT_LEFT;
            else if (right == 1'b1) next_state = WAIT_RIGHT;
            else next_state = WAIT_MOVE;
        end
        else next_state = DRAW_CAR;
    end
    WAIT_MOVE:
    begin
        if (forward == 1'b1 && oneframe) next_state = MOVE_CAR;
        else if (left == 1'b1 || right == 1'b1) next_state = MOVE_CAR;
        else next_state = WAIT_MOVE;
    end
    STRAIGHT: next_state = DRAW_CAR;

    LEFT: next_state = DRAW_CAR;

    WAIT_LEFT: next_state = left ? WAIT_LEFT : WAIT_MOVE;

    RIGHT = next_state = DRAW_CAR;

    WAIT_RIGHT = next_state = right ? WAIT_RIGHT : WAIT_MOVE;

    DRAW_WIN:
    begin
        if (done_win)
        begin
            if (start) next_state = DRAW_WIN;
            else next_state = SET_RESET_SIGNAL;
        end
        else next_state = DRAW_WIN;
    end
    MOVE_CAR:
    begin
        if (done_clear)
        begin
            if (forward == 1'b1) next_state = STRAIGHT;
            else if (left == 1'b1) next_state = LEFT;
            else if (right == 1'b1) next_state = RIGHT;
            else next_state = DRAW_CAR;
        end
        else next_state = MOVE_CAR;
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
    draw_win = 1'b0;  
    draw_menu = 1'b0; 
    drive = 1'b0;
    resetsignal = 1'b0;
    clear = 1'b0;

case (current_state)
    DRAW_MENU: 
    begin
        draw_menu = 1'b1;
    end
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
    MOVE_CAR:
    begin
        if (clear)
    end
    SET_RESET_SIGNAL = resetsignal = 1'b1;
endcase

end

module datapath ()

endmodule