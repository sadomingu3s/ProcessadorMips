module ROM (
    input [31:0] addres,
    input clk,
    output reg [31:0] saida
);

  reg [31:0] rom[999:0];

  initial begin
    $readmemb("programa.txt", rom);
  end
  always @(posedge clk) begin
    saida <= rom[addres];
  end
endmodule

// "C:\Users\wilso\AppData\Local\Programs\Microsoft VS Code\Code.exe"  -g %f:%l
