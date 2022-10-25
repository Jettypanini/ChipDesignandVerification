`include "generator.sv"

program test();

  generator gen = new();

  initial
  begin
    gen.run();
  end

endprogram : test
