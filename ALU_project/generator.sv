`include "transaction.sv"

class generator;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) gen2mdl;

  function new(mailbox #(transaction) g2d, mailbox #(transaction) g2m);
    this.gen2drv = g2d;
    this.gen2mdl = g2m;
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
      tra.logical_90percent.constraint_mode(1);
      void'(tra.randomize()); 
      tra.instruction[7:6] = tra.instruction_type;
      tra.instruction[5:3] = tra.instruction_selection;
      tra.instruction[2:0] = tra.operand_selection;
      tra.data_in[7:6] = tra.ld_instruction_type;
      tra.data_in[5:3] = tra.reg_src;
      tra.data_in[2:0] = tra.reg_dest;
      s = $sformatf("[%t | GEN] new instruction %s", $time, tra.toString());
      $display(s);
      s = $sformatf("[%t | GEN] new data %s", $time, tra.dataToString());
      $display(s);
      this.gen2drv.put(tra);
      this.gen2mdl.put(tra);
    end
  endtask : run

endclass : generator
