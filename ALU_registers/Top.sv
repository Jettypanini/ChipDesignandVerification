
/***
 * Test environment
 ***/
module Top;
  logic clock=0;

  // clock generation - 100 MHz
  always #5 clock = ~clock;

  // instantiate an interface
  ALU_iface i1( .clock(clock) );

  // instantiate the DUT and connect it to the interface
  ALU DUT(
	.A(i1.A),
 	.B(i1.B),
	.flags_in(i1.flags_in),
	.Z(i1.Z),
	.flags_out(i1.flags_out),
	.operation(i1.operation)
  );

  // provide stimuli
  initial begin
    i1.A <= 'h01;
    i1.B <= 'h00;

    repeat (256) @(posedge clock) begin
      i1.B <= i1.B + 1;
    end;
    $finish;
  end

endmodule