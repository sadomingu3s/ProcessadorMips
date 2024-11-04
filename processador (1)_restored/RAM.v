module RAM(
input [31:0]end_escrita,
input [31:0]dado,
input [31:0]end_leitura,
input clk,
input sinal_escrita,
output reg [31:0]dado_leitura
);

reg [31:0] ram[999:0]; //cria a ram

always @(posedge clk)
begin
	dado_leitura<= ram[end_leitura]; // pega da mem
end

always @(negedge clk) begin
	if(sinal_escrita) begin
		ram[end_escrita] <= dado; //escreve na mem de dados 
	end
end

endmodule