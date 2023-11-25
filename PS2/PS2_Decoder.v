
module PS2_Receiver (
input clock, reset, PS2_clock, PS2_data,
output [7:0] Key_code,
output flag
)

reg [3:0] current_state, next_state;
reg f = 1'b0;
reg [7:0] B;
wire PS2C, PS2D;

localparam start = 4'd0,
b0 = 4'd1,
b1 = 4'd2,
b2 = 4'd3,
b3 = 4'd4,
b4 = 4'd5,
b5 = 4'd6,
b6 = 4'd7,
b7 = 4'd8,
parity = 4'd9,
stop = 4'd10;

always @(negedge PS2C)
begin
    if (reset)
        current_state <= start;
    else
        current_state <= next_state;
end

always @(*)
begin
    begin
        case (current_state)
        start: next_state = b0;
        b0: next_state = b1;
        b1: next_state = b2;
        b2: next_state = b3;
        b3: next_state = b4;
        b4: next_state = b5;
        b6: next_state = b7;
        b7: next_state = parity;
        parity: next_state = stop;
        stop: next_state = start;
        default: next_state = start;
        endcase
    end
end

always @(*)
begin
    begin
        case (current_state)
            start: f = 1'b0;
            b0: B[0] = PS2D;
            b1: B[0] = PS2D;
            b2: B[0] = PS2D;
            b3: B[0] = PS2D;
            b4: B[0] = PS2D;
            b5: B[0] = PS2D;
            b6: B[0] = PS2D;
            b7: B[0] = PS2D;
            parity: f = 1'b1;
            stop: f = 1'b0;
        endcase
    end
end

assign flag = f;
assign Key_code = B;

endmodule 


