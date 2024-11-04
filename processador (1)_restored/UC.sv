module UC (
    input [5:0] opcode,
    input Zflag,
    input Nflag,
    input halt_button,
    output reg out,
    output reg [1:0] regDst,
    output reg jr,
    output reg jump,
    output reg branch,
    output reg leMem,
    output reg [1:0] memParaReg,
    output reg [3:0] opUla,
    output reg escreveMem,
    output reg oringUla,
    output reg escreveReg,
    output reg fHalt,
    output reg fHaltIN
);


  parameter RUNNING = 0, HALTED = 1, WAITING_INPUT = 2;


  always @(*) begin

    out = 0;
    fHaltIN = 0;
    regDst = 2'b00;
    jr = 0;
    jump = 0;
    branch = 0;
    leMem = 0;
    memParaReg = 2'b00;
    opUla = 4'b0000;  //ADD
    escreveMem = 0;
    oringUla = 0;
    escreveReg = 0;
    fHalt = 0;

    case (opcode)
      //ADD
      6'b000000: begin
        regDst = 2'b01;
        escreveReg = 1;
      end
      //ADDI
      6'b000001: begin
        oringUla   = 1;
        escreveReg = 1;
        memParaReg = 2'b00;

      end
      //SUB
      6'b000010: begin
        regDst = 2'b01;
        escreveReg = 1;
        opUla = 4'b0001;
      end

      //SUBI
      6'b000011: begin
        regDst = 2'b00;
        escreveReg = 1;
        opUla = 4'b0001;
        oringUla = 1;
      end
      //AND
      6'b000100: begin
        opUla = 4'b0010;
        regDst = 2'b01;
        escreveReg = 1;
      end
      //ANDI
      6'b000101: begin
        regDst = 2'b01;
        escreveReg = 1;
        opUla = 4'b0010;
        oringUla = 1;
      end
      //OR
      6'b000110: begin
        opUla = 4'b0110;
        regDst = 2'b01;
        escreveReg = 1;
      end
      //ORI
      6'b000111: begin
        regDst = 2'b01;
        escreveReg = 1;
        opUla = 4'b0110;
        oringUla = 1;
      end
      //LOAD
      6'b001000: begin
        //	regDst <= 2b'01 
        escreveReg = 1;
        oringUla   = 1;
        //opUla= 4'b0000 //ADD
        memParaReg = 2'b01;

      end

      //STORE
      6'b001001: begin
        //regDst <= 2'b00
        oringUla   = 1;
        escreveMem = 1;
        memParaReg = 2'b01;
        escreveReg = 1;

      end
      //BEQ
      6'b001010: begin
        opUla  = 4'b0001;
        branch = Zflag;
      end
      //BNQ 
      6'b001011: begin
        opUla  = 4'b0001;
        branch = ~Zflag;
      end
      //JUMP
      6'b001100: begin
        jump = 1;
      end
      //JR
      6'b001101: begin
        jr = 1;
      end
      //JAL
      6'b001110: begin
        regDst = 2'b10;  //ra 
        escreveReg = 1;
        jump = 1;

        memParaReg = 2'b10;  //endereço do pc+1
      end
      //NOP
      6'b001111: begin
      end
      //HALT
      6'b010000: begin
        fHalt = 1;
      end
      //BLT
      6'b010001: begin
        opUla  = 4'b0001;
        branch = Nflag;
      end
      //MULT
      6'b010010: begin
        regDst = 2'b01;
        escreveReg = 1;
        opUla = 4'b0011;
      end
      //LOADIN
      6'b010011: begin
        //regDst = 2'b01;
        escreveReg = 1;
        memParaReg = 2'b11;
        fHaltIN = 1;
      end




      //DIV
      6'b010100: begin
        opUla = 4'b0100;  //div
        regDst = 2'b01;
        escreveReg = 1;
      end
      //OUT
      6'b010101: begin
        out = 1;

      end

      default: begin
        out = 0;
        fHaltIN = 0;
        regDst = 2'b00;
        jr = 0;
        jump = 0;
        branch = 0;
        leMem = 0;
        memParaReg = 2'b00;
        opUla = 4'b0000;  //ADD
        escreveMem = 0;
        oringUla = 0;
        escreveReg = 0;
        fHalt = 0;

      end


    endcase

  end





endmodule




