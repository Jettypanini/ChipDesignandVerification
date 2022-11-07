`include "transaction.sv"

class verif;


  mailbox #(transaction) gen2chk;
  mailbox #(reg[15:0]) mon2chk;
  mailbox #(int) chk2scb;

  function new(mailbox #(transaction) g2c, mailbox #(reg[15:0]) m2c, mailbox #(transaction) c2s);
    this.gen2chk = g2c;
    this.mon2chk = m2c;
    this.chk2scb = c2s;
  endfunction : new

  task run;

  string s;
    transaction tra;
    
    $timeformat(-9,0," ns" , 10);

    s = $sformatf("[%t | CHK] I will check your results", $time);
    $display(s);

  forever 
    begin

    end /* forever */

  endtask : run

endclass : verif