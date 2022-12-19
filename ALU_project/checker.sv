`include "tra_probe.sv"

class verif;

  mailbox #(tra_probe) mon2chk;
  mailbox #(tra_probe) mdl2chk;
  mailbox #(bit) chk2scb;

  function new(mailbox #(tra_probe) m2c, mailbox #(tra_probe) md2c, mailbox #(bit) c2s);
    this.mon2chk = m2c;
    this.mdl2chk = md2c;
    this.chk2scb = c2s;
  endfunction : new

  task run; 
    tra_probe tra_mon;
    tra_probe tra_mdl;

    string s;

    $timeformat(-9,0," ns" , 10);
    s = $sformatf("[%t | CHE] I will start checking", $time);
    $display(s);

    forever 
    begin  
      this.mon2chk.get(tra_mon);
      this.mdl2chk.get(tra_mdl);

      tra_mon.show();
      tra_mdl.show();

      if (tra_mon.regA == tra_mdl.regA & tra_mon.regB == tra_mdl.regB & tra_mon.regC == tra_mdl.regC & tra_mon.regD == tra_mdl.regD & tra_mon.regE == tra_mdl.regE & tra_mon.regF == tra_mdl.regF & tra_mon.regH == tra_mdl.regH & tra_mon.regL == tra_mdl.regL)
      begin
        this.chk2scb.put(bit'(1));
      end else begin
        this.chk2scb.put(bit'(0));
      end
    end
  endtask
  
endclass : verif
