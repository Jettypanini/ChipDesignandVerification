`include "tra_probe.sv"

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

    bit [1:0] instruction_type;
    bit [2:0] instruction_selection;
    bit [2:0] operand_selection;
    
    mailbox #(transaction) gen2mdl;
    mailbox #(tra_probe) mdl2chk;

    /* Upon creating an object, the registers
      are initialised. A simplication was done,
      because the LOAD instructions are not 
      implemented. Hence, all values are constant 
      (except for those of A and F).*/
    function new(mailbox #(transaction) g2m, mailbox #(tra_probe) m2c);
        this.A = 0;
        this.B = 1;
        this.C = 2;
        this.D = 3;
        this.E = 4;
        this.F = 0;
        this.H = 5;
        this.L = 6;
        this.gen2mdl = g2m;
        this.mdl2chk = m2c;
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
    task executeALUInstruction();
        string s;
        transaction tra;
        tra_probe probe;
        byte val_reg;
    
        probe = new();
        forever
        begin

            this.gen2mdl.get(tra);
            s = $sformatf("[%t | MDL] received and calculating: %s", $time, tra.toString());
            $display(s);
            this.instruction_type = tra.instruction[7:6];
            this.instruction_selection = tra.instruction[5:3];
            this.operand_selection = tra.instruction[2:0];

            if (this.instruction_type == 2'h10)
            begin
              case (operand_selection)
                0 : begin
                      val_reg = B;
                    end
                1 : begin
                      val_reg = C;
                    end
                2 : begin
                      val_reg = D;
                    end
                3 : begin
                      val_reg = E;
                    end
                4 : begin
                      val_reg = H;
                    end
                5 : begin
                      val_reg = L;
                    end
                // Value of HL is ignored.
                //6 : begin
                //      val_reg = HL;
                //    end
                7 : begin
                      val_reg = A;
                    end
              endcase
              s = $sformatf("[%t | MDL] Value loaded: %x", $time, val_reg);
              $display(s);

            end

            probe.regA = A;
            probe.regB = B;
            probe.regC = C;
            probe.regD = D;
            probe.regE = E;
            probe.regF = F;
            probe.regH = H;
            probe.regL = L;

            this.mdl2chk.put(probe);
        end

    endtask : executeALUInstruction

endclass : gameboyprocessor
