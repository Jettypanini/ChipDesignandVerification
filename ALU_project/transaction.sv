`ifndef TRANSACTION_SV
`define TRANSACTION_SV

class transaction;
  byte instruction;
  byte data_in;

  rand bit [1:0] instruction_type;
  rand bit [2:0] instruction_selection;
  rand bit [2:0] operand_selection;
  rand bit [1:0] ld_instruction_type;
  rand bit [2:0] reg_src;
  rand bit [2:0] reg_dest;

  function new();
    this.instruction_type = 2'h0;
    this.instruction_selection = 3'h0;
    this.operand_selection = 3'h0;
    this.ld_instruction_type = 2'h0;
    this.reg_src = 3'h0;
    this.reg_dest = 3'h0;
  endfunction : new

  function string toString();
    return $sformatf("Instruction: %08x", this.instruction);
  endfunction : toString

  function string dataToString();
    return $sformatf("Data: %08x", this.data_in);
  endfunction : dataToString  

endclass : transaction;

`endif