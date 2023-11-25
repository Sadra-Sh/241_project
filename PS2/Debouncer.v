module debouncer #(parameter NDEB_Cycles = 10) 
(input clock, input reset, input button_in, output button_out)

reg [31:0] counter;

reg button_old = 1'b0;
reg button_temp = 1'b0;

always @(posedge clock)

begin
    if (reset)
    begin
        counter <= 0;
        button_temp <= 0;
        button_old <= 0;
    end
    else
    begin
        if (button_in == button_old)
        begin
            if (counter == NDEB_Cycles-1)
            begin
                button_temp <= button_in;
                counter <= counter;
            end
            else
            counter <= counter + 1'b1;
        end
        else
        begin
            counter <= 0;
            button_old <= button_in;
        end
    end
end
assign button_out = button_temp;

endmodule