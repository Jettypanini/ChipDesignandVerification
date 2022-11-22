`include "ALU_iface.sv"
`include "test.sv"

/***
 * Test environment
 ***/
module Top;
  logic clock=0;

  // clock generation - 100 MHz
  always #5 clock = ~clock;

  // instantiate an interface
  ALU_iface i1( .clock(clock) );

  gbprocessor gb_inst(
    .reset(i1.reset),
    .clock(clock),
    .instruction(i1.instruction),
    .valid(i1.valid),
    .probe(i1.probe)
  );

  test test1(i1);

   covergroup sbc_xor @(posedge clock);
    option.at_least = 100;

    cp_ALU_instruction_type: coverpoint i1.instruction[5:3]
    iff(i1.valid) {
      bins xorAfterSbc = (3=>5);
    }
  endgroup

  covergroup cp1000 @(posedge clock);
    option.at_least = 1000;

    cp_ALU_instruction_type: coverpoint i1.instruction[5:3]
    iff(i1.valid) {
      bins pc = {7};
    }
  endgroup

  covergroup subE @(posedge clock);
    option.at_least = 20;

    cp_ALU_instruction_type: coverpoint i1.instruction[5:0]
    iff(i1.valid) {
      bins subAndE = {6'b011011};
    }
  endgroup

  covergroup arith3log1 @(posedge clock);
    cp_ALU_instruction_type: coverpoint i1.instruction[5:3]
    iff(i1.valid) {
      bins xorAfterSbc = (3=>5);
    }
  endgroup

  covergroup logregA @(posedge clock);
    option.at_least = 327;

    cp_ALU_instruction_type: coverpoint i1.instruction[5] iff(i1.valid) {
            bins logical = {1};
        }

        cp_ALU_second_operand: coverpoint i1.instruction[2:0] iff(i1.valid){
            bins regA = {7};
        }

    cx: cross cp_ALU_instruction_type, cp_ALU_second_operand {
      bins logNotA = binsof(cp_ALU_instruction_type.logical) && !binsof(cp_ALU_second_operand.regA);
    }
  endgroup

  initial begin
    sbc_xor sbc_xor_inst;
    cp1000 cp1000_inst;
    subE subE_inst;
    arith3log1 arith3log1_inst;
    logregA logregA_inst;

    cp1000_inst = new();
    sbc_xor_inst = new();
    subE_inst = new();
    arith3log1_inst = new();
    logregA_inst = new();

  end

endmodule