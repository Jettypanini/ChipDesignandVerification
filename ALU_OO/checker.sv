
class checker;


  mailbox #(transaction) gen2chk;
  mailbox #(transaction) mon2chk;
  mailbox #(transaction) chk2scb;

  function new(mailbox #(transaction) g2c, mailbox #(transaction) m2c, mailbox #(transaction) c2s);
    this.gen2chk = g2c;
    this.mon2chk = m2c;
    this.chk2scb = c2s;
  endfunction : new

  task run;

  endtask : run

endclass : checker