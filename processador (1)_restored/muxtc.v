module muxtc (
input [31:0]a,
input [31:0]b,
input [31:0]c,
input [31:0]d,
input [1:0]sel,
output reg [31:0]saida
);

always@(*)
begin
	saida = 32'bX;
case(sel)
	3'b000: saida = a;
	3'b001: saida = b;
	3'b010: saida = c;
	3'b011: saida = d;
endcase
end






endmodule