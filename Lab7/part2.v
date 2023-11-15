module toplevel (Clock_50, KEY, SW);
    input Clock_50,
    input [3:0] KEY,
    input [9:0] SW,

    part2 u1 (.iClock(Clock_50), .iResetn(KEY[0]), .iPlotBox(KEY[1]), .iBlack(KEY[2]), .iLoadX(KEY[3]), .iXY_Coord([6:0]SW), .iColour([9:7]SW));

endmodule

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
   wire lx, ly, lc;
   wire [7:0] counterx, countery;
   
   control c0(
   .clk(iClock),
   .reset(iResetn),
   .load_x(iLoadX),
   .iplot(iPlotBox),
   .black(iBlack),
   .counterx(counterx),
   .countery(countery),
   .oplot(oPlot),
   .odone(oDone),
   .lx(lx),
   .ly(ly),
   .lc(lc)  
   );

   datapath d0(
   .clk(clock),
   .reset(iResetn),
   .lx(lx),
   .ly(ly),
   .lc(lc),
   .plot(iPlotBox),
   .black(iBlack),
   .xycoord(iXY_Coord),
   .color(iColour),
   .xout(oX),
   .yout(oY),
   .cout(oColour),
   .counterx(counterx),
   .countery(countery)
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
output reg lx, ly, lc
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
         if (counterx == 8'd3 && countery == 8'd3)
         next_state = done;
         else
         next_state = draw;
      end
      done: next_state = set_x;
      clear_wait: next_state = black ? clear_wait : clear;
      clear:
      begin
         if (counterx == 8'd159 && countery == 8'd119)
            next_state = done;
         else 
            next_state = clear;
      end
      default: next_state = set_x;
   endcase
end

always @(posedge clk)
begin
   case (current_state)
      set_x:
      begin
         lx = 1'b1;
         ly = 1'b0;
         lc = 1'b0;
      end
      set_y:
      begin
         lx = 1'b0;
         ly = 1'b1;
         lc = 1'b1;
      end
      draw:
      begin
         lx = 1'b0;
         ly = 1'b0;
         lc = 1'b0;
         oplot = 1'b1;
         odone = 1'b0;
      end
      done:
      begin
         lx = 1'b0;
         ly = 1'b0;
         lc = 1'b0;
         odone = 1'b1;
      end
      clear:
      begin
         odone = 1'b0;
         oplot = 1'b1;
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
   input lx, ly, lc,
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
   end
   else
   begin
      if (lx)
      xpoint <= {1'b0, xycoord};
      if (ly)
      ypoint <= xycoord;
      if (lc)
      cout <= color;
   end
end

always @(posedge clk)
begin
  if (black) 
  begin
   counterx <= counterx + 1'b1;
   countery <= countery + 1'b1;
   xout <= counterx;
   yout <= countery;
   cout <= 3'b0;
  end

  else 
  begin
   if (plot) 
   begin
      if (!reset) 
      begin
      xout <= 8'b0;
      yout <= 8'b0;
      counterx <= 8'b0;
      countery <= 8'b0;
      cout <= 3'b0;
      end
      else
      begin
         xout <= xpoint + counterx;
         yout <= ypoint + countery;
         cout <= color;
         counterx <= counterx + 1'b1;
         countery <= countery + 1'b1;
      end
   end
   else
   begin
      xout <= xout;
      yout <= yout;
   end
  end
end
endmodule
