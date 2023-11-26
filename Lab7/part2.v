module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot,oDone);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;

   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire iClock;
   output wire [7:0] oX; // VGA pixel coordinates
   output wire [6:0] oY;

   output wire [2:0] oColour; // VGA pixel colour (0-7)
   output wire oPlot; // Pixel draw enable
   output wire oDone; // goes high when finished drawing frame
   wire lx, ly, lc, increment;
   wire [7:0] countx, county;

   
   control c0(
   .clk(iClock),
   .reset(iResetn),
   .load_x(iLoadX),
   .iplot(iPlotBox),
   .black(iBlack),
   .counterx(countx),
   .countery(county),
   .oplot(oPlot),
   .odone(oDone),
   .lx(lx),
   .ly(ly),
   .lc(lc),
   .inc(increment)  
   );

   datapath d0(
   .clk(iClock),
   .reset(iResetn),
   .lx(lx),
   .ly(ly),
   .lc(lc),
   .inc(increment),
   .done(oDone),
   .plot(oPlot),
   .black(iBlack),
   .xycoord(iXY_Coord),
   .color(iColour),
   .xout(oX),
   .yout(oY),
   .cout(oColour),
   .counterx(countx),
   .countery(county)
   );
   //
   // Your code goes here
   //
endmodule // part2

module control (
input clk, reset,
input load_x,
input iplot, black, 
input [7:0] counterx, countery,
output reg oplot, odone,
output reg lx, ly, lc, inc
);
reg [3:0] current_state, next_state;
localparam set_x_wait = 3'd0,
set_x = 3'd1,
set_y_wait = 3'd2,
set_y = 3'd3,
draw = 3'd4,
done = 3'd5,
clear_wait = 3'd6, 
clear = 3'd7;
always @(*)
begin
   case (current_state)
      set_x_wait : 
      begin
         if(load_x)
            next_state = set_x;
         else if (black)
            next_state = clear_wait;
         else
            next_state = set_x_wait;
      end   
      set_x : next_state = load_x ? set_x : set_y_wait;
      set_y_wait : next_state = iplot ? set_y : set_y_wait;
      set_y : next_state = iplot ? set_y : draw;
      draw:
      begin
         if (countery == 8'd4)
         begin
            next_state = done;
            oplot = 1'b0;
            current_state <= next_state;
         end
         else
         next_state = draw;
      end
      done: next_state = set_x;
      clear_wait: next_state = black ? clear_wait : clear;
      clear:
      begin
         if (countery == 8'd120)
         begin
            next_state = done;
            oplot = 1'b0;
            current_state <= next_state;
         end
         else 
            next_state = clear;
      end
      default: next_state = set_x;
   endcase
end

always @(posedge clk)
begin
lx = 1'b0;
ly = 1'b0;
lc = 1'b0;
inc = 1'b0;
oplot = 1'b0;
odone = 1'b0;
   case (current_state)
      set_x:
      begin
         lx = 1'b1;
      end
      set_y:
      begin
         ly = 1'b1;
         lc = 1'b1;
      end
      draw:
      begin
         oplot = 1'b1;
         odone = 1'b0;
         if (counterx == 8'd2)
         inc = 1'b1;
      end
      done:
      begin
         odone = 1'b1;
         oplot = 1'b0;
      end
      clear:
      begin
         odone = 1'b0;
         oplot = 1'b1;
         if (counterx == 8'd159)
         inc = 1'b1;
      end
   endcase
end
always@(posedge clk)
begin 
   if(!reset)
      current_state <= set_x_wait;
   else
      current_state <= next_state;
end // state_FFS
endmodule

module datapath(
   input clk, reset,
   input lx, ly, lc, inc, done,
   input plot, black,
   input [6:0] xycoord,
   input [2:0] color,
   output reg [7:0] xout,
   output reg [6:0] yout,
   output reg [2:0] cout,
   output reg [7:0] counterx, countery
);
reg [7:0] xpoint;
reg [6:0] ypoint;
always @(posedge clk)
begin
   if (!reset) 
   begin
      xout <= 8'b0;
      yout <= 7'b0;
      cout <= 3'b0;
      counterx <= 8'b0;
      countery <= 8'b0;
   end
   else
   begin
      if (lx)
      xpoint <= {1'b0, xycoord};
      if (ly)
      ypoint <= xycoord;
      if (lc)
      cout <= color;
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
      if (done)
      begin
         countery <= 8'b0;
         counterx <= 8'b0;
      end
   end
end

always @(*)
begin
  if (black) 
  begin
   xout <= xpoint + counterx;
   yout <= ypoint + countery;
   cout <= 3'b0;
  end
  if (plot) 
   begin
      xout <= xpoint + counterx;
      yout <= ypoint + countery;
      cout <= color;
   end
end
endmodule
