module BANCOREG (
    endRegDest,
    endOp1,
    endOp2,
    r1,
    r2,
    sinalEscrita,
    clk,
    dado,
    reset
);

  input [4:0] endRegDest;  //endereçamento de 5 bits
  input [4:0] endOp1;
  input [4:0] endOp2;
  input sinalEscrita, clk;
  input reset;

  input [31:0] dado;

  output wire [31:0] r1;  //r1 é o dado que vai pra ULA
  output wire [31:0] r2;

  reg [31:0] bancoReg[31:0];  //32 registradores de tam 32bits

  assign r1 = bancoReg[endOp1];
  assign r2 = bancoReg[endOp2];



  integer i;

  always @(negedge clk) begin
    if (reset) begin
      for (i = 0; i < 32; i = i + 1) begin
        bancoReg[i] <= 32'b0;
      end
    end else if (sinalEscrita) begin
      bancoReg[endRegDest] <= dado;  // bloco sincrono clk
    end
  end
endmodule
