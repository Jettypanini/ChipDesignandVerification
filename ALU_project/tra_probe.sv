`ifndef TRA_PROBE_SV
`define TRA_PROBE_SV

class tra_probe;
  byte regA;
  byte regB;
  byte regC;
  byte regD;
  byte regE;
  byte regF;
  byte regH;
  byte regL;

  logic [8*8-1:0] probe;

  function new();
    this.regA = 0;
    this.regB = 1;
    this.regC = 2;
    this.regD = 3;
    this.regE = 4;
    this.regF = 0;
    this.regH = 5;
    this.regL = 6;
  endfunction : new

  function string show();
        $display("REG A : %02X \t\t REG F : %02X", this.regA, this.regF);
        $display("REG B : %02X \t\t REG C : %02X", this.regB, this.regC);
        $display("REG D : %02X \t\t REG E : %02X", this.regD, this.regE);
        $display("REG H : %02X \t\t REG L : %02X", this.regH, this.regL);
        return $sformatf("%02X %02X %02X %02X %02X %02X %02X %02X", this.regA, this.regF, this.regB, this.regC, this.regD, this.regE, this.regH, this.regL);
  endfunction : show 

  function setProbe(logic [8*8-1:0] regs);
    this.regA = regs[63:56];
    this.regB = regs[55:48];
    this.regC = regs[47:40];
    this.regD = regs[39:32];
    this.regE = regs[31:24];
    this.regF = regs[23:16];
    this.regH = regs[15:8 ];
    this.regL = regs[ 7:0 ];
  endfunction: setProbe

endclass : tra_probe;

`endif