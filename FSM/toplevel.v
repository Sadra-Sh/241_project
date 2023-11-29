module toplevel(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot,oDone);
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
endmodule