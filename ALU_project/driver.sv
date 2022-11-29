`include "transaction.sv"

class driver;

  virtual ALU_iface ifc;
  mailbox #(transaction) gen2drv;

  function new(virtual ALU_iface ifc, mailbox #(transaction) g2d);
    this.ifc = ifc;
    this.gen2drv = g2d;
  endfunction : new

  task run_addition();
    string s;
    transaction tra;
    
    $timeformat(-9,0," ns" , 10);

    s = $sformatf("[%t | DRV] I will start driving from the mailbox", $time);
    $display(s);

    /* start with reset */
      this.ifc.reset <= 1'b1;
      repeat(10) @(posedge this.ifc.clock);

      this.ifc.reset <= 1'b0;
      repeat(10) @(posedge this.ifc.clock);

    forever 
    begin    

      this.ifc.valid <= 1'b0;
      this.gen2drv.get(tra);

      @(posedge this.ifc.clock);

      this.ifc.valid <= 1'b1;
      this.ifc.instruction <= tra.instruction;
      this.ifc.data_in <= tra.data_in;

      s = $sformatf("[%t | DRV] driving %s", $time, tra.toString());
      $display(s);

      @(posedge this.ifc.clock);

    end /* forever */

    s = $sformatf("[%t | DRV] done", $time);
    $display(s);
         
  endtask : run_addition

endclass : driver
