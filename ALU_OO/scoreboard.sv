`include "transaction.sv"

class scoreboard;

  mailbox #(int) chk2scb;

  function new(mailbox #(int) c2s);
    this.chk2scb = c2s;
  endfunction : new

  task run;

  string s;
    int tra;
    int score;
    
    $timeformat(-9,0," ns" , 10);

    s = $sformatf("[%t | SCB] I will keep the score", $time);
    $display(s);
    
    forever 
    begin

    this.chk2scb.get(tra);
    score = score + 1;

    if (score == 100)
      break;

    end /* forever */
  endtask : run

endclass : scoreboard