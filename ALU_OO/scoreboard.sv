`include "transaction.sv"

class scoreboard;

  mailbox #(int) chk2scb;

  function new(mailbox #(int) c2s);
    this.chk2scb = c2s;
  endfunction : new

  task run;

  string s;
    int tra;
    
    $timeformat(-9,0," ns" , 10);

    s = $sformatf("[%t | SCB] I will keep the score", $time);
    $display(s);
    
    forever 
    begin

    end /* forever */
  endtask : run

endclass : scoreboard