module part2
#(parameter CLOCK_FREQUENCY = 50000000)(
input ClockIn,
input Reset,
input [1:0] Speed,
output [3:0] CounterValue
);

wire c;
RateDivider #(.CLOCK_FREQUENCY(CLOCK_FREQUENCY)) u0 (.ClockIn(ClockIn), .Reset(Reset), .Speed(Speed), .Enable(c));
DisplayCounter u1 (.Clock(ClockIn), .Reset(Reset), .EnableDC(c), .CounterValue(CounterValue));

endmodule

module RateDivider
#(parameter CLOCK_FREQUENCY = 50000000) (
input ClockIn,
input Reset,
input [1:0] Speed,
output Enable
);
reg [$clog2(CLOCK_FREQUENCY*4)-1: 0] downCount;

always @(posedge ClockIn)
begin
    if (Reset || downCount == 28'd0)
    begin
        if (Speed == 2'b00)
            downCount <= 27'd0;
        else if (Speed == 2'b01)
            downCount <= CLOCK_FREQUENCY-1;
        else if (Speed == 2'b10)
            downCount <= (CLOCK_FREQUENCY*2)-1;
        else if (Speed == 2'b11)
            downCount <= (CLOCK_FREQUENCY*4)-1;
    end

    else

    begin
        if (Speed == 2'b0)
        downCount <= downCount + 1;
        else
        downCount <= downCount - 1;
    end
end

assign Enable = (downCount == 0) ? 1'b1:1'b0;

endmodule

module DisplayCounter (
input Clock,
input Reset,
input EnableDC,
output [3:0] CounterValue
);

reg [3:0] Counter;
assign CounterValue = Counter;

always @(posedge Clock)
begin
    if (Reset)
        Counter <= 0;

    else if (EnableDC)
        Counter <= Counter + 1;
end

endmodule