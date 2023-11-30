module toplevel(iResetn, iClock, oX, oY, oColour, start, done, plot);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;

   input wire start;
   input wire iClock iResetn;
   output wire [7:0] oX; // VGA pixel coordinates
   output wire [7:0] oY;

   output wire [2:0] oColour; // VGA pixel colour (0-7)
   output wire plot, done; // Pixel draw enable
   wire [7:0] counterx, countery;
   wire bg_black, bg_green_left, bg_green_right, draw_car, update, erase, inc;

   control c0 (
      .clock(iClock),
      .reset(iResetn),
      .start(start),
      .counterx(counterx),
      .countery(countery),
      .draw_bg_black(bg_black),
      .draw_bg_green_left(bg_green_left),
      .draw_bg_green_right(bg_green_right),
      .draw_car(draw_car),
      .update_car(update),
      .erase(erase),
      .inc(inc),
      .done(done),
      .plot(plot)
   );

   datapath d0 (
      .clock(iClock),
      .reset(iResetn),
      .draw_bg_black(bg_black),
      .draw_bg_green_left(bg_green_left),
      .draw_bg_green_right(bg_green_right),
      .draw_car(draw_car),
      .erase(erase),
      .update(update),
      .done(done),
      .plot(plot),
      .counterx(counterx),
      .countery(countery),
      .xout(oX),
      .yout(oY),
      .cout(oColour)
   );

endmodule