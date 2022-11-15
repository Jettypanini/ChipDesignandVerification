
/***
 * The interface
 ***/
interface ALU_iface ( input logic clock );
  logic reset;
  logic [7:0] instruction;
  logic valid;
  logic [2*8-1:0] probe;
endinterface