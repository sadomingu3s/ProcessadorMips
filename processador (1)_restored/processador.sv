module processador (
    input clkIn,
    input reset,
    input [15:0] IN,
    input halt_button,
    //output[31:0] OUT,
    output [6:0] display7seg0,
    output [6:0] display7seg1,
    output [6:0] display7seg2,
    output [6:0] display7seg3,
    output fHaltIN
);

	wire clk_div;
	clock u_clock (
		.clk_in (fHaltIN ? 0 : clkIn),
      .clk_out(clk_div)
  );

  // wire fHaltIN;
  wire fHalt;
  wire clk;
  wire halt;
  reg [1:0] current_state;

  assign clk = fHaltIN ? ~halt_button : clk_div;

  wire [31:0] OUT;

  wire [5:0] opcode;
  wire [31:0] address;
  wire [31:0] saida_mux_jump;
  wire [31:0] saida_mux_jr;
  wire [31:0] saida_mux_branch;
  wire [31:0] saida_BancoReg1;
  wire [31:0] saida_BancoReg2;
  wire [31:0] dado_escrita;
  wire [31:0] saidaULA1;
  wire [31:0] saidaULA2;
  wire [31:0] resultadoULA;
  wire [31:0] dado_imediato_ULA;  //depende de MUX
  wire [31:0] saida_ram;

  wire [31:0] imediato;
  wire [31:0] end_jump;


  wire [31:0] end_leitura;

  //flags
  wire load = 1;
  wire inc = 0;
  wire fOut;

  wire jr;
  wire jump;
  wire Zflag;
  wire Nflag;
  wire [3:0] opULA;
  wire [1:0] regDst;
  wire sinalEscritaReg;
  wire branch;
  wire oringULA;
  wire escreveMem;
  wire selectIN;
  wire [1:0] memParaReg;
  wire leMem;
  wire escreveReg;
  wire [4:0] endRegDest;

  wire [31:0] address_entrada;  //linha do programa

  PC program_counter (
      .address(address_entrada),
      .clk(clk),  //para processamento
      .reset(reset),  //flag
      .load(~fHalt),  //flag
      .inc(inc),  //flag
      .current_address(end_leitura)
  );

  //

  wire [31:0] instruction;

  assign opcode = instruction[31:26];


  //MEMORIA DE PROGRAMA	

  ROM rom (
      .addres(end_leitura),
      .clk(clk),
      .saida(instruction)
  );
  //


  //MUX_REG_ESCRITA

  MUXTB #(
      .tam_dado(5)  //end tem 5 bits
  ) MUX_REG_ESCRITA (
      .a(instruction[20:16]),  //RD
      .b(instruction[15:11]),  //RT
      .c(5'd31),  //RA
      .sel(regDst),  //flag
      .saida(endRegDest)
  );
  //


  //BANCO DE REGISTRADORES

  BANCOREG T1 (
      .endRegDest(endRegDest),  //depende do mux
      .endOp1(instruction[25:21]),
      .endOp2(instruction[20:16]),
      .r1(saida_BancoReg1),
      .r2(saida_BancoReg2),
      .sinalEscrita(sinalEscritaReg),  //flag
      .clk(clk),
      .dado(dado_escrita),
      .reset(reset)
  );  //flag
  //

  //MUX_ESCOLHE_OPULAB

  MUXTA #(
      .tam_dado(32)
  ) mux_OpB (
      .sel(oringULA),
      .a(saida_BancoReg2),
      .b(imediato),
      .saida(saidaULA2)
  );


  //


  //ULA

  ULA ula (
      .a(saida_BancoReg1),
      .b(saidaULA2),
      .sel(opULA),  //vem da UC
      .r(resultadoULA),
      .Nflag(Nflag),  //flag
      .Zflag(Zflag)
  );  //flag

  //


  //RAM

  RAM ram (
      .end_escrita(resultadoULA),
      .dado(saida_BancoReg2),
      .end_leitura(resultadoULA),
      .clk(clk),
      .sinal_escrita(escreveMem),
      .dado_leitura(saida_ram)
  );

  //




  //MUX_JUMP
  MUXTA #(
      .tam_dado(32)
  ) mux_jump (
      .sel(jump),
      .a((end_leitura) + 32'b1),  //extender sinal
      .b(end_jump),
      .saida(saida_mux_jump)
  );


  //MUX_JR
  MUXTA #(
      .tam_dado(32)
  ) mux_jr (
      .sel(jr),
      .a(saida_mux_jump),
      .b(saida_BancoReg1),
      .saida(saida_mux_jr)
  );



  //
  extensor_bit extensor1 (
      .sel(1),
      .saida(end_jump),
      .entrada1(instruction[25:0]),
      .entrada2(0)  //tanto faz
  );
  //
  //extende imediato da instrução
  extensor_bit extensor2 (
      .sel(0),
      .saida(imediato),
      .entrada1(0),  //tanto faz
      .entrada2(instruction[15:0])
  );

  wire [31:0] INEX;

  extensor_bit extensor3 (
      .sel(0),
      .saida(INEX),
      .entrada1(0),  //tanto faz
      .entrada2(IN)
  );
  //

  //MUX_BRANCH
  MUXTA #(
      .tam_dado(32)
  ) mux_branch (
      .sel(branch),
      .a(saida_mux_jr),
      .b((end_leitura + 1) + imediato),  //extensor de sinal
      .saida(address_entrada)
  );



  //UC
  //
  //reg [5:0]opcode;


  UC unidade_de_controle (
      .opcode(opcode),
      .Zflag(Zflag),
      .Nflag(Nflag),
      .halt_button(halt_button),
      .out(fOut),
      .regDst(regDst),
      .jr(jr),
      .jump(jump),
      .branch(branch),
      .leMem(leMem),
      .memParaReg(memParaReg),
      .opUla(opULA),
      .escreveMem(escreveMem),
      .oringUla(oringULA),
      .escreveReg(sinalEscritaReg),
      .fHalt(fHalt),
      .fHaltIN(fHaltIN)
  );


  //MUX_OUT
  muxtc MUXTC (
      .a(resultadoULA),
      .b(saida_ram),
      .c((end_leitura) + 32'b1),
      .d(INEX),
      .sel(memParaReg),
      .saida(dado_escrita)
  );
  //


  //assign OUT = dado_escrita;

  wire [31:0] data_out;
  assign OUT = data_out;

  registerOUT rOut (
      .data_in(dado_escrita),
      .data_out(data_out),
      .clk(clk),
      .load(fOut),
      .reset(reset)
  );


  //mod out

  wire [3:0] bcd[3:0];

  out moduloOUT (
      .entrada(OUT),
      .controle(1),
      .clock(clk),
      .d0(bcd[0]),
      .d1(bcd[1]),
      .d2(bcd[2]),
      .d3(bcd[3])
  );
  //

  displayBcd displaybcd0 (
      .bcd(bcd[0]),
      .seg(display7seg0)
  );

  displayBcd displaybcd1 (
      .bcd(bcd[1]),
      .seg(display7seg1)
  );

  displayBcd displaybcd2 (
      .bcd(bcd[2]),
      .seg(display7seg2)
  );

  displayBcd displaybcd3 (
      .bcd(bcd[3]),
      .seg(display7seg3)
  );





endmodule
