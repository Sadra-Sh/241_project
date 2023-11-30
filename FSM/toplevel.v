module toplevel(iResetn, iClock, oX, oY, oColour, start);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;

   input wire iClock;
   output wire [7:0] oX; // VGA pixel coordinates
   output wire [7:0] oY;

   output wire [2:0] oColour; // VGA pixel colour (0-7)
   output wire oPlot; // Pixel draw enable

endmodule