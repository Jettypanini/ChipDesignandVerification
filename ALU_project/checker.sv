`include "transaction.sv"

class verif;

  mailbox #(shortint) mon2chk;
  mailbox #(bit) chk2scb;

  function new(mailbox #(shortint) m2c, mailbox #(bit) c2s);
    this.mon2chk = m2c;
    this.chk2scb = c2s;
  endfunction : new

  task run; 
    shortint expected_result, received_result;
    transaction tra;

    string s;

    $timeformat(-9,0," ns" , 10);
    s = $sformatf("[%t | CHE] I will start checking", $time);
    $display(s);

    forever 
    begin  
      this.mon2chk.get(received_result);

      /* do something to get the.
         For now, have this placeholder */
      received_result = expected_result;

      if (received_result == expected_result)
      begin
        this.chk2scb.put(bit'(1));
      end else begin
        this.chk2scb.put(bit'(0));
      end
    end
  endtask
  
endclass : verif
