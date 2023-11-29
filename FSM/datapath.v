module datapath (
input clock, reset,
input draw_bg, draw_car, drive, resetsignal, erase, plot
input color,
output reg [7:0] xcounter, ycounter, xout, yout,
)
reg [7:0] xpoint, ypoint;

always @(posedge clock)
begin
    if (!reset)
        xout <= 8'b0;
        yout <= 8'b0;
        counterx <= 8'b0;
        countery <= 8'b0;
    else
    if (plot)
      begin
         if (inc)
         begin
            countery <= countery + 1'b1;
            counterx <= 8'b0;
         end
         else
            counterx <= counterx + 1'b1;
      end
      if (done_car || done_erase || done_bg)
      begin
         countery <= 8'b0;
         counterx <= 8'b0;
      end
end

always @(*)
begin
    if (draw_bg || erase)
        xout <= xpoint + counterx;
        yout <= ypoint + countery;
        // color
    if (draw_car)
        xout <= xpoint + counterx;
        yout <= ypoint + countery;
        //color
end

endmodule