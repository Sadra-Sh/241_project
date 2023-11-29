module datapath (
input clock, reset,
input draw_bg_black, draw_bg_green_left, draw_bg_green_right, 
input draw_car, erase, plot,
input done_bg, done_car, done_erase, done_update, 
output reg [7:0] xcounter, ycounter, xout, yout,
output reg [2:0] cout,
);
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
    if (done_bg || done_car || done_erase || done_update)
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
   xout <= 8'd30 + counterx;
   yout <= 8'd0 + countery;
   cout <= 3'b0;
  end
  else if (draw_bg_green_left)
  begin
    xout <= 8'd0 + counterx;
    yout <= 8'd0 + countery;
    cout <= 3'b010;
  end
  else if (draw_bg_green_right)
  begin
    xout <= 8'd130 + counterx;
    yout <= 8'd0 + countery;
  end
  else if (draw_car) 
   begin
      xout <= 8'd80 + counterx;
      yout <= 8'd60 + countery;
      cout <= 3'b100;
   end
end
endmodule
