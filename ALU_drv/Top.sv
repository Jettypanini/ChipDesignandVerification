
/***
 * Test environment
 ***/
module Top;
  logic clock=0;

  // clock generation - 100 MHz
  always #5 clock = ~clock;

  // instantiate an interface
  gbprocessor_iface i1( .clock(clock) );

  // instantiate the DUT and connect it to the interface
  gbprocessor gb_inst(
    .reset(i1.reset),
    .clock(clock),
    .instruction(i1.instruction),
    .valid(i1.valid),
    .probe(i1.probe)
  );

  // provide stimuli
  initial begin
  i1.instruction <= 'h00;
    repeat (256) @(posedge clock) begin
      i1.instruction <= i1.instruction + 1;
    end;
    $finish;
  end

endmodule