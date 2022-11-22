`ifndef TRANSACTION_SV
`define TRANSACTION_SV

class transaction;
  byte instruction;

  rand bit [1:0] instruction_type;
  rand bit [2:0] instruction_selection;
  rand bit [2:0] operand_selection;

  function new();
    this.instruction_type = 2'h0;
    this.instruction_selection = 3'h0;
    this.operand_selection = 3'h0;
  endfunction : new

  function string toString();
    return $sformatf("Instruction: %08x", this.instruction);
  endfunction : toString

  constraint c1 {
    instruction_selection[2] dist { 0 := 3, 1 := 1};
  }

endclass : transaction;

`endif