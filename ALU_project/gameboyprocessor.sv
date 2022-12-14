`include "transaction.sv"
`include "tra_probe.sv"

/* A new class is made for the model :) */
class gameboyprocessor;

  virtual ALU_iface ifc;  

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
    
    bit [7:0] data_in;
    
    mailbox #(transaction) gen2mdl;
    mailbox #(tra_probe) mdl2chk;
    mailbox #(tra_probe) mon2chk;

    /* Upon creating an object, the registers
      are initialised. A simplication was done,
      because the LOAD instructions are not 
      implemented. Hence, all values are constant 
      (except for those of A and F).*/
    function new(virtual ALU_iface ifc, mailbox #(transaction) g2m, mailbox #(tra_probe) md2c, mailbox #(tra_probe) m2c);
        this.ifc = ifc;
        this.A = 0;
        this.B = 1;
        this.C = 2;
        this.D = 3;
        this.E = 4;
        this.F = 0;
        this.H = 5;
        this.L = 6;
        this.mon2chk = m2c;
        this.gen2mdl = g2m;
        this.mdl2chk = md2c;
    endfunction : new

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
          @(negedge this.ifc.clock);

          if (this.ifc.valid == 1)
          begin
            this.gen2mdl.get(tra);
            s = $sformatf("[%t | MDL] received and calculating: %s", $time, tra.toString());
            $display(s);
            this.instruction_type = tra.instruction[7:6];
            this.instruction_selection = tra.instruction[5:3];
            this.operand_selection = tra.instruction[2:0];
            this.data_in = tra.data_in;

            if (this.instruction_type == 0 & this.operand_selection == 6)
            begin
              case(instruction_selection)
                0:  begin
                      this.B = this.data_in;
                    end
                1:  begin
                      this.C = this.data_in;
                    end
                2:  begin
                      this.D = this.data_in;
                    end
                3:  begin
                      this.E = this.data_in;
                    end
                4:  begin
                      this.H = this.data_in;
                    end
                5:  begin
                      this.L = this.data_in;
                    end
                7:  begin
                      this.A = this.data_in;                      
                    end
              endcase
            end

            if (this.instruction_type == 1)
            begin
              case(operand_selection)
                0:  begin
                      val_reg = this.B;
                    end
                1:  begin
                      val_reg = this.C;
                    end
                2:  begin
                      val_reg = this.D;
                    end
                3:  begin
                      val_reg = this.E;
                    end
                4:  begin
                      val_reg = this.H;
                    end
                5:  begin
                      val_reg = this.L;
                    end
                7:  begin
                      val_reg = this.A;                     
                    end
              endcase

              case(instruction_selection)
                0:  begin
                      this.B = val_reg;
                    end
                1:  begin
                      this.C = val_reg;
                    end
                2:  begin
                      this.D = val_reg;
                    end
                3:  begin
                      this.E = val_reg;
                    end
                4:  begin
                      this.H = val_reg;
                    end
                5:  begin
                      this.L = val_reg;
                    end
                7:  begin
                      this.A = val_reg;                      
                    end
              endcase
            end

            if (this.instruction_type == 2)
            begin
              case (operand_selection)
                0 : begin
                      val_reg = this.B;
                    end
                1 : begin
                      val_reg = this.C;
                    end
                2 : begin
                      val_reg = this.D;
                    end
                3 : begin
                      val_reg = this.E;
                    end
                4 : begin
                      val_reg = this.H;
                    end
                5 : begin
                      val_reg = this.L;
                    end
                // Value of HL is ignored.
                //6 : begin
                //      val_reg = HL;
                //    end
                7 : begin
                      val_reg = this.A;
                    end
              endcase
              
              case(instruction_selection)
                0:  begin
                      this.A = this.A + val_reg;
                    end
                1:  begin
                      this.A = this.A + val_reg;
                    end
                2:  begin
                      this.A = this.A - val_reg;
                    end
                3:  begin
                      this.A = this.A - val_reg;
                    end
                4:  begin
                      this.A = this.A & val_reg;
                    end
                5:  begin
                      this.A = this.A ^ val_reg;
                    end
                6:  begin
                      this.A = this.A | val_reg;
                    end
                7:  begin
                      if (this.A < val_reg)
                      begin
                        this.F[4] = 1'b1; 
                      end else
                      begin
                        this.F[4] = 1'b0; 
                      end
                      
                    end
              endcase
            end

            probe.regA = this.A;
            probe.regB = this.B;
            probe.regC = this.C;
            probe.regD = this.D;
            probe.regE = this.E;
            probe.regF = this.F;
            probe.regH = this.H;
            probe.regL = this.L;

            s = $sformatf("[%t | MDL] I calculated with %x", $time, tra.instruction);
            $display(s);
            probe.show();

            this.mdl2chk.put(probe);
          end
        end

    endtask : executeALUInstruction

endclass : gameboyprocessor
