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
      if (this.mon2chk.try_get(tra_mon))
      begin
        this.mdl2chk.get(tra_mdl);

        tra_mon.show();
        tra_mdl.show();

        if (tra_mon.getProbe() == tra_mdl.getProbe())
        begin
          this.chk2scb.put(bit'(1));
        end else begin
          this.chk2scb.put(bit'(0));
        end
      end
      
    end
  endtask
  
endclass : verif
