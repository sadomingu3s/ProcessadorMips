module MUXTA#(parameter tam_dado = 32)(
input sel,
input [tam_dado-1:0]a,
input [tam_dado-1:0]b,
output reg [tam_dado-1:0] saida);

always@(*)
begin

case(sel)

1'b0 : saida = a;
1'b1 : saida = b;

endcase
end


endmodule