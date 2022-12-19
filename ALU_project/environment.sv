`include "transaction.sv"
`include "tra_probe.sv"
`include "generator.sv"
`include "gameboyprocessor.sv"
`include "driver.sv"
`include "monitor.sv"
`include "checker.sv"
`include "scoreboard.sv"

class environment;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) gen2mdl;
  mailbox #(tra_probe) mdl2chk;
  mailbox #(tra_probe) mon2chk;
  mailbox #(bit) chk2scb;

  virtual ALU_iface ifc;

  generator gen;
  gameboyprocessor mdl;
  driver drv;
  monitor mon;
  verif chk;
  scoreboard scb;

  function new(virtual ALU_iface ifc, shortint gen_state, shortint drv_state, shortint mon_state);
    this.ifc = ifc;

    this.gen2drv = new(1);
    this.gen2mdl = new(1);
    this.mdl2chk = new(1);
    this.mon2chk = new(1);
    this.chk2scb = new(1);

    this.gen = new(this.gen2drv, this.gen2mdl);
    this.mdl = new(ifc, this.gen2mdl, this.mdl2chk);
    this.drv = new(ifc, this.gen2drv);
    this.mon = new(ifc, this.mon2chk);
    this.chk = new(this.mon2chk, this.mdl2chk, this.chk2scb);
    this.scb = new(this.chk2scb);
  endfunction : new

  task run();
    string s;

    $timeformat(-9,0," ns" , 10);

    s = $sformatf("[%t | ENV] I will set up the components", $time);
    $display(s);

    fork
      this.drv.run_addition();
      this.mdl.executeALUInstruction();
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
