`include "driver.sv"
`include "monitor.sv"

class environment;

  virtual gbprocessor_iface ifc;

  driver drv;
  monitor mon;

  function new(virtual gbprocessor_iface ifc);
    this.drv = new(ifc);
    this.mon = new(ifc);
  endfunction : new

  task run();
    this.drv.run_addition();
    this.mon.run();
  endtask : run

endclass : environment