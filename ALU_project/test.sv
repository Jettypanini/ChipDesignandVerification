`include "environment.sv"

program test(ALU_iface i1);

  environment env1 = new(i1, 0, 0, 0);

  // provide stimuli
  initial begin
    env1.run();
  end

endprogram : test
