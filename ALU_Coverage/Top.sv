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

  covergroup cp1000 @(posedge clock);
    option.at_least = 1000;

    cp_ALU_instruction_type: coverpoint ALU_iface.instruction[5:3]
    iff(ALU_iface.valid) {
      bin pc = 7;
    }

  endgroup

  initial begin
    assignment4 assignment4_inst;

    assignment4_inst = new();
  end

endmodule