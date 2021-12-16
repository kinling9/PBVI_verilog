module PBVI_decision(
  input logic clk,
  input logic rst_n,
  input logic [15:0] trans [2:0][1:0][1:0],
  input logic [15:0] observe [1:0][1:0][1:0],
  input logic [15:0] alpha [15:0],
  input logic [15:0] belief [15:0][1:0],
  input logic [15:0] current_belief,
  output logic [1:0] action,
  output logic [15:0] renew_belief
);
endmodule