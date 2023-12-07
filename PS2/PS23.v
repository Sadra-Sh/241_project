module PS23 (
    input PS2_CLK,
    input PS2_DAT,

    output reg p1, p2, space

);
    reg [7:0] dat;
    reg [3:0] b = 0;
    reg done, break;

    always @(negedge PS2_CLK) begin
        if (b==0);
        else if (b==9) 
            done <= 1;

        else if (b==10) 
            done <= 0;
        else 
            dat[b-1] <= PS2_DAT;

        if (b==10)
            b <= 0;
        
        else 
            b <= b+1;

    end

    always @(posedge done) begin
        if (dat == 8'hF0) begin
            break <= 1;
        end

        else begin
            if (dat == 8'h1A) p1 <= !break;
            else if (dat == 8'h3A) p2 <= !break;
            else if (dat == 8'h29) space <= !break;

            break <= 0;
        end

    end
endmodule
