`include "environment.sv"

/***
 * Test environment
 ***/
module Top;
  logic clock=0;

  // clock generation - 100 MHz
  always #5 clock = ~clock;

  // instantiate an interface
  ALU_iface i1( .clock(clock) );

  environment env1;

  // provide stimuli
  initial begin
    env1 = new(i1);
    env1.run();
  end

endmodule