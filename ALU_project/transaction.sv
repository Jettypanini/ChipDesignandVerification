`ifndef TRANSACTION_SV
`define TRANSACTION_SV

class transaction;
  byte instruction;
  byte data_in;

  rand bit [1:0] instruction_type;
  rand bit [2:0] instruction_selection;
  rand bit [2:0] operand_selection;
  rand bit [7:0] data8;

  function new();
    this.instruction_type = 2'h0;
    this.instruction_selection = 3'h0;
    this.operand_selection = 3'h0;
    this.data8 = 8'h0;
  endfunction : new

  function string toString();
    return $sformatf("Instruction: %08x", this.instruction);
  endfunction : toString

  function string dataToString();
    return $sformatf("Data: %08x", this.data_in);
  endfunction : dataToString  

  constraint logical_90percent {
    instruction_type dist {2 := 90, [0:1] :/7, 3 := 3};
  }

endclass : transaction;

`endif