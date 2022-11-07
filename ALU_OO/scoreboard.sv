`include "transaction.sv"

class scoreboard;

  mailbox #(int) chk2scb;

  function new(mailbox #(int) c2s);
    this.chk2scb = c2s;
  endfunction : new

  task run;

  string s;
    int tra;
    int score = 0;
    
    $timeformat(-9,0," ns" , 10);

    s = $sformatf("[%t | SCB] I will keep the score", $time);
    $display(s);
    
    forever 
    begin

    this.chk2scb.get(tra);
    score = score + tra;

    if (score == 100) begin
      s = $sformatf("[%t | SCB] Test report", $time);
      $display(s);
      s = $sformatf("[%t | SCB] ----------------", $time);
      $display(s);
      s = $sformatf("[%t | SCB] # tests done               : 100", $time);
      $display(s);
      s = $sformatf("[%t | SCB] # tests ok                 : 100", $time);
      $display(s);
      s = $sformatf("[%t | SCB] # tests failed             : 0", $time);
      $display(s);
      s = $sformatf("[%t | SCB] # tests success rate       : 100.0", $time);
      $display(s);
      //break;
    end

    end /* forever */
  endtask : run

endclass : scoreboard