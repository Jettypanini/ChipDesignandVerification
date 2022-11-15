`include "environment.sv"

program test(ALU_iface i1);

  environment env1;
  env1 = new(i1);

  // provide stimuli
  initial begin
    env1.run();
  end

endprogram : test
