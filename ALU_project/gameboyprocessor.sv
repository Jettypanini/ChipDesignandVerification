/* A new class is made for the model :) */
class gameboyprocessor;

    /* Eight 8-bit registers */
    byte A;
    byte B;
    byte C;
    byte D;
    byte E;
    byte F;
    byte H;
    byte L;

    
  mailbox #(transaction) gen2mdl;

    /* Upon creating an object, the registers
      are initialised. A simplication was done,
      because the LOAD instructions are not 
      implemented. Hence, all values are constant 
      (except for those of A and F).*/
    function new(mailbox #(transaction) g2m);
        this.A = 0;
        this.B = 1;
        this.C = 2;
        this.D = 3;
        this.E = 4;
        this.F = 0;
        this.H = 5;
        this.L = 6;
        this.gen2mdl = g2m;
    endfunction : new

    /* A simple to string function to 
      consult the internals. */
    task toString();
        $display("REG A : %02X \t\t REG F : %02X", this.A, this.F);
        $display("REG B : %02X \t\t REG C : %02X", this.B, this.C);
        $display("REG D : %02X \t\t REG E : %02X", this.D, this.E);
        $display("REG H : %02X \t\t REG L : %02X", this.H, this.L);
    endtask : toString


    /* Here is the bread-and-butter of the 
       model. Similar to the DUT, an instruction
       can be fed to the model. The model 
       performs the same operation on its 
       internal registers as the DUT. */
    task executeALUInstruction(byte instr);
      
        transaction tra;
    
        forever
        begin

            this.gen2drv.get(tra);
            s = $sformatf("[%t | MDL] received: %s", $time, tra.toString());
            $display(s);

        end

    endtask : executeALUInstruction

endclass : gameboyprocessor
