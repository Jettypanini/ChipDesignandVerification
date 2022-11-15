`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "checker.sv"
`include "scoreboard.sv"

class environment;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) gen2chk;
  mailbox #(shortint) mon2chk;
  mailbox #(bit) chk2scb;

  virtual ALU_iface ifc;

  generator gen;
  driver drv;
  monitor mon;
  verif chk;
  scoreboard scb;

  function new(virtual ALU_iface ifc);
    this.ifc = ifc;

    this.gen2drv = new(100);
    this.gen2chk = new(100);
    this.mon2chk = new(100);
    this.chk2scb = new(100);

    this.gen = new(this.gen2drv, this.gen2chk);
    this.drv = new(ifc, this.gen2drv);
    this.mon = new(ifc, this.mon2chk);
    this.chk = new(this.mon2chk, this.chk2scb);
    this.scb = new(this.chk2scb);
  endfunction : new

  task run();
    string s;

    $timeformat(-9,0," ns" , 10);

    s = $sformatf("[%t | ENV] I will set up the components", $time);
    $display(s);

    fork
      this.drv.run_addition();
      this.mon.run();
      this.chk.run();
      this.scb.run(100);
      this.gen.run();
    join_any;
    disable fork;

    scb.showReport();

    s = $sformatf("[%t | ENV]  end of run()", $time);
    $display(s);

  endtask : run

endclass : environment
