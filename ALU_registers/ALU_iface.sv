
/***
 * The interface
 ***/
interface ALU_iface ( input logic clock );
  logic [7:0] A;
  logic [7:0] B;
  logic [3:0] flags_in;
  logic [7:0] Z;
  logic [3:0] flags_out;
  logic [2:0] operation;
endinterface