class transaction;

  rand bit [1:0] instruction_type;
  rand bit [2:0] instruction_selection;
  rand bit [2:0] operand_selection;

  function new();
    this.instruction_type = 2'h0;
    this.instruction_selection = 3'h0;
    this.operand_selection = 3'h0;
  endfunction : new

  function string toString();
    return $sformatf("Instruction: %02x %02x %02x (%02x) ", this.instruction_type, this.instruction_selection, this.operand_selection, this.toByte);
  endfunction : toString

  function byte toByte();
    return byte'(this.instruction_type * 2**(6) + this.instruction_selection * 2**(3) + this.operand_selection);
  endfunction : toByte;

  constraint instructionWithA {
    (instruction_selection inside {3'b000, 3'b001, 3'b100});
  }

  constraint cpChance20 {
    instruction_selection dist {7 := 2, [0:6] :/8};
  }

endclass : transaction


program assignment3();
    transaction tra;
    int i;
    int j;
    bit sub;
    int cp;

    initial
    begin
      tra = new();

      // Test 1
      tra.instructionWithA.constraint_mode(0);
      tra.cpChance20.constraint_mode(0);

      tra.instruction_type.rand_mode(0);
      tra.instruction_selection.rand_mode(0);
      tra.instruction_type = 2'b10;

      $display("Test 1: start");

      for (i=0; i<8; i++) begin
        tra.instruction_selection = i;
        for (j=0; j<100; j++) begin
          void'(tra.randomize()); 
          $display(tra.toString);
        end
      end
      $display("Test 1: done \n");

      // Test 2
      tra.instructionWithA.constraint_mode(1);
      tra.cpChance20.constraint_mode(0);

      tra.instruction_type.rand_mode(0);
      tra.instruction_selection.rand_mode(1);
      tra.instruction_type = 2'b10;

      $display("Test 2: start");

      for (i=0; i<100; i++) begin
        void'(tra.randomize()); 
        $display(tra.toString);
      end
      $display("Test 2: done \n");

      // Test 3
      tra.instructionWithA.constraint_mode(0);
      tra.cpChance20.constraint_mode(0);

      tra.instruction_type.rand_mode(0);
      tra.instruction_selection.rand_mode(1);
      tra.instruction_type = 2'b10;

      $display("Test 3: start");

      for (i=0; i<100; i++) begin
        void'(tra.randomize()); 

        if (sub) begin
          tra.instruction_selection = 3'b101;
          sub = 0;
          $display($sformatf("Instruction: %02x %02x %02x (%02x) <------------------- !!!", tra.instruction_type, tra.instruction_selection, tra.operand_selection, tra.toByte));
        end else begin
          if (tra.instruction_selection == 3'b010) begin
            sub = 1;
          end
          $display(tra.toString);
        end
      end
      $display("Test 3: done \n");

      // Test 4
      tra.instructionWithA.constraint_mode(0);
      tra.cpChance20.constraint_mode(1);

      tra.instruction_type.rand_mode(0);
      tra.instruction_selection.rand_mode(1);
      tra.instruction_type = 2'b10;

      cp = 0;

      $display("Test 4: start");

      for (i=0; i<1000; i++) begin
        void'(tra.randomize()); 
        $display(tra.toString);
        if (tra.instruction_selection == 3'b111 && !sub) begin
          cp = cp+1;
        end
      end
      $display($sformatf("ratio: (cp vs non cp):          %d         %d", cp/10, 100-(cp/10)));
      $display("Test 4: done \n");


    end


endprogram : assignment3
