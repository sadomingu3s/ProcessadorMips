module extensor_bit(sel,saida,entrada1,entrada2);

input sel;
input [25:0]entrada1;
input [15:0]entrada2;


output reg [31:0]saida;


always@(*)
begin
saida = 32'b0;

case(sel)

	1'b1: begin
	if(entrada1[25] == 1'b1)begin
	saida = entrada1 + 32'b11111100000000000000000000000000;
	end
	else begin
	saida = entrada1+ 32'b0;
	end
	end
	1'b0 : begin
	if(entrada2[15] == 1'b1) begin
	saida = entrada2 + 32'b11111111111111110000000000000000;
	end
	else begin
	saida = entrada2 +32'b0;
	end
	
	end
	endcase
	
end

endmodule