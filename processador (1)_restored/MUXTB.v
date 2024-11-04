module MUXTB #(parameter tam_dado = 32)(
input [tam_dado-1:0]a,
input [tam_dado-1:0]b,
input [tam_dado-1:0]c,
input [1:0]sel,
output reg [tam_dado-1:0]saida
);

always@(*)
begin
	saida = 32'bX;
case(sel)
	3'b000: saida = a;
	3'b001: saida = b;
	3'b010: saida = c;
endcase
end



endmodule