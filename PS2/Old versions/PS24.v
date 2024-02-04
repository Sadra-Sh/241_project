module NewPS2(
    input CLOCK_50,
    input [9:0] SW,
    input PS2_CLK,
    input PS2_DAT,

    output reg Wenable,
    output reg Aenable,
    output reg Senable,
    output reg Denable
);
    reg [10:0] bitcount;
    reg [10:0] ps2Data;

    always @(posedge SW) begin
        
        bitcount <= 1'b0;
        Wenable <= 1'b0;
        Aenable <= 1'b0;
        Senable <= 1'b0;
        Denable <= 1'b0;
    
    end

    always @(negedge PS2_CLK) begin

        if (bitcount == 4'd11) begin
            if (ps2Data[8:1] == 8'h1D) begin //W
                Wenable <= 1'b1;
                Aenable <= 1'b0;
                Senable <= 1'b0;
                Denable <= 1'b0;
            end
            else if (ps2Data[8:1] == 8'h1C) begin // A
                Wenable <= 1'b0;
                Aenable <= 1'b1;
                Senable <= 1'b0;
                Denable <= 1'b0; 
            end           
            else if (ps2Data[8:1] == 8'h23) begin//D
                Wenable <= 1'b0;
                Aenable <= 1'b0;
                Senable <= 1'b0;
                Denable <= 1'b1;            end
            else if (ps2Data[8:1] == 8'h1B) begin //S
                Wenable <= 1'b0;
                Aenable <= 1'b0;
                Senable <= 1'b1;
                Denable <= 1'b0;            end
        end

        else  begin
            ps2Data <= {PS2_DAT, ps2Data[9:0]};
            bitcount <= bitcount + 1;
        end

    end
endmodule
