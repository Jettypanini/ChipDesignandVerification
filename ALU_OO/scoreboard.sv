`include "transaction.sv"

class scoreboard;

  mailbox #(transaction) chk2scb;

  function new(mailbox #(transaction) c2s);
    this.chk2scb = c2s;
  endfunction : new

  task run;
    
    forever 
    begin

    end /* forever */
  endtask : run

endclass : scoreboard