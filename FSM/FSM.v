module control (
input clock,
input reset,
input start,
input straight, 
input right,
input left, 
input done_menu,
input done_bg,
input done_car,
input done_win, 
input done_race,
input done_clear,
output reg start_race, 
output reg draw_bg, 
output reg draw_car, 
output reg draw_win, 
output reg draw_clear, 
output reg draw_menu, 
output reg drive,
output reg plot,
)
reg [3:0] current_state, next_state;

localparam DRAW_MENU = 4'd0,
START_RACE = 4'd1,
DRAW_BG = 4'd2,
DRAW_CAR = 4'd3,
WAIT_DRIVE = 4'd4,
STRAIGHT = 4'd5,
LEFT = 4'd6,
RIGHT = 4'd7,
DRAW_WIN = 4'8,

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
    
    endcase
end

endmodule

module datapath ()

endmodule