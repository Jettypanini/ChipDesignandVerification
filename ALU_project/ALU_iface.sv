
/***
 * The interface
 ***/
interface ALU_iface ( input logic clock );
  logic reset;
  logic [7:0] instruction;
  logic [7:0] data;
  logic valid;
  logic [8*8-1:0] probe;
endinterface