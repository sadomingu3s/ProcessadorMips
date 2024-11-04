module dev (
    //////////// CLOCK //////////
    input         CLOCK_50,
    // //////////// SEG7 //////////
    output [ 6:0] HEX0,
    output [ 6:0] HEX1,
    output [ 6:0] HEX2,
    output [ 6:0] HEX3,
    /////////// PUSH BUTTON ////
    input  [ 3:0] KEY,
    input  [17:0] SW,
    /////////// LEDS //////////
    output [17:0] LEDR,
    output [ 8:0] LEDG
);
  wire clk;

//  clock u_clock (
//      .clk_in (CLOCK_50),
//      .clk_out(clk)
//  );

  wire halt_button = ~KEY[0];
  assign LEDG[2] = clk;
  assign LEDG[3] = halt_button;

  processador u_processador (
      .clkIn       (CLOCK_50),
      .reset       (SW[17]),
      .IN          (SW[15:0]),
      .halt_button (halt_button),
      .display7seg0(HEX0),
      .display7seg1(HEX1),
      .display7seg2(HEX2),
      .display7seg3(HEX3),
      .fHaltIN     (LEDG[4])
  );



endmodule
