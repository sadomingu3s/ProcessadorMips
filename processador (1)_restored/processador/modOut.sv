
module out (entrada, controle, clock, d0, d1, d2, d3);

input wire [31:0] entrada;
input clock, controle;
output wire [3:0] d1, d2, d3, d0;

wire [3:0] reg_display0 = (entrada % 10);
wire [3:0] reg_display1 = (entrada % 100) / 10;
wire [3:0] reg_display2 = (entrada % 1000) / 100;
wire [3:0] reg_display3 = (entrada % 10000) / 1000;

assign d0 = (controle ? reg_display0 : 4'b1111);
assign d1 = (controle ? reg_display1 : 4'b1111);
assign d2 = (controle ? reg_display2 : 4'b1111);
assign d3 = (controle ? reg_display3 : 4'b1111);

endmodule
