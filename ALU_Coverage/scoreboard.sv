class scoreboard;

  mailbox #(bit) chk2scb;

  int NO_tests;

  int no_tests_done;
  int no_tests_ok;
  int no_tests_nok;

  function new(mailbox c2s);
    this.chk2scb = c2s;
    NO_tests = 0;
    no_tests_done = 0;
    no_tests_ok = 0;
    no_tests_nok = 0;
  endfunction : new

  task run(int NOT);
    byte result;
    string s;
    this.NO_tests = NOT;

    $timeformat(-9,0," ns" , 10);
    s = $sformatf("[%t | SCB] I will start keeping score", $time);
    $display(s);

    while ($get_coverage() < 100)
    begin
      this.chk2scb.get(result);

      no_tests_done++; 
      
      if (result > 0)
      begin 
        no_tests_ok++; 
        //$display("[SCB] successful test registered");
      end else begin
        no_tests_nok++;
        //$display("[SCB] unsuccessful test registered");
      end
    end /* while*/
  endtask : run


  task showReport;
    $display("[SCB] Test report");
    $display("[SCB] ------------");
    $display("[SCB] # tests done         : %0d", this.no_tests_done);
    $display("[SCB] # tests ok           : %0d", this.no_tests_ok);
    $display("[SCB] # tests failed       : %0d", this.no_tests_nok);
    $display("[SCB] # tests success rate : %0.2f", this.no_tests_ok/this.no_tests_done*100);
  endtask : showReport


endclass : scoreboard