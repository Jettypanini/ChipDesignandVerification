`include "transaction.sv"

class generator;

  mailbox #(transaction) gen2drv;

  function new(mailbox #(transaction) g2d);
    this.gen2drv = g2d;
  endfunction : new

  task run;
    string s;
    transaction tra;

    $timeformat(-9,0," ns" , 10);

    s = $sformatf("[%t | GEN] I will start generating for the mailbox", $time);
    $display(s);

    forever
    begin
      tra = new();
      void'(tra.randomize()); 
      tra.instruction[7:6] = tra.instruction_type;
      tra.instruction[5:3] = tra.instruction_selection;
      tra.instruction[2:0] = tra.operand_selection;
      s = $sformatf("[%t | GEN] new instruction %s", $time, tra.toString());
      $display(s);
      this.gen2drv.put(tra);
    end
  endtask : run

endclass : generator
