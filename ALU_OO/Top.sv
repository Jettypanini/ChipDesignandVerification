
/***
 * Test environment
 ***/
module Top;
  logic clock=0;

  // clock generation - 100 MHz
  always #5 clock = ~clock;

  // instantiate an interface
  ALU_iface i1( .clock(clock) );

  environment env1 = new(this.i1);

  // provide stimuli
  initial begin
    this.env1.run();
  end

endmodule