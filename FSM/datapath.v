module datapath (
input clock, reset,
input draw_bg_black, draw_bg_green_left, draw_bg_green_right, 
input draw_car, drive, erase, plot,
output reg [7:0] xcounter, ycounter, xout, yout,
)
reg [7:0] xpoint, ypoint;
reg [2:0] regcolor;
always @(posedge clk)
begin
   if (reset) 
   begin
      xout <= 8'b0;
      yout <= 7'b0;
      cout <= 3'b0;
      counterx <= 8'b0;
      countery <= 8'b0;
   end
   else
   begin
    if (inc)
    begin
        countery <= countery + 1'b1;
        counterx <= 8'b0;
    end
    else
        counterx <= counterx + 1'b1;
    if (done)
      begin
         countery <= 8'b0;
         counterx <= 8'b0;
      end
   end
end

always @(*)
begin
  if (draw_bg_black) 
  begin
   xout <= xpoint + counterx;
   yout <= ypoint + countery;
   cout <= 3'b0;
  end
  else if (draw_bg_green_left || draw_bg_green_right)
  begin
    xout <= xpoint + counterx;
    yout <= ypoint + countery;
    cout <= 3'b010;
  end
  else if (draw_car) 
   begin
      xout <= xpoint + counterx;
      yout <= ypoint + countery;
      cout <= 3'b100;
   end
end
endmodule