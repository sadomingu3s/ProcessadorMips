module ULA (a,b,sel,r,Nflag,Zflag);

input [3:0] sel;
input [31:0] a,b;

reg[31:0] r0;
output reg [31:0] r;

output Nflag,Zflag;


always@(*)
begin
r = 32'bX;

case(sel[3:0])
4'b0000 : r = a + b;  //ADD
4'b0001 : r = a - b;	//SUB
4'b0010 : r = a & b; //AND
4'b0011 : r = a * b; //MUL
4'b0100 : r = a / b; //DIV
4'b0101 : r = ~a; //NOT
4'b0110 : r = a || b;//OR

endcase
end

always@(*)
begin
r0 = r;
end

assign Nflag = r[31]; //bit responsável pelo sinal

assign Zflag = ~|r0; //checando se existe algum 1

endmodule

