`include "tra_probe.sv"

class monitor;

  /* Virtual interface */
  virtual ALU_iface ifc;

  mailbox #(tra_probe) mon2chk;

  /* Constructor */
  function new(virtual ALU_iface ifc, mailbox #(tra_probe) m2c);
    this.ifc = ifc;
    this.mon2chk = m2c;
  endfunction : new

  /* run method */
  task run();
    string s;
    byte a, b, z;
    bit sample = 0;
    byte instruction;
    byte data_in;
    tra_probe tra;
    
    $timeformat(-9,0," ns" , 10); /* format timing */

    /* print message */
    s = $sformatf("[%t | MON] I will start monitoring", $time);
    $display(s);
    tra = new();

    forever begin
      /* wait for falling edge of the clock */
      @(negedge this.ifc.clock);

      /* if sampling is required, sample */
      if(sample == 1)
      begin
        s = $sformatf("[%t | MON] I sampled %x (with %x %x)", $time, this.ifc.probe, instruction, data_in);
        $display(s);

        tra.setProbe(this.ifc.probe);
        this.mon2chk.put(tra);

        sample = 0;
      end 

      /* determine whether sampling is required */
      if(this.ifc.valid == 1)
      begin
        sample = 1;
        instruction = this.ifc.instruction;
        data_in = this.ifc.data_in;
      end /* if valid */
        
    end /* forever */
  endtask : run

endclass : monitor
