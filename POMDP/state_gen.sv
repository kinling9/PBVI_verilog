module obs_gen(
  input logic clk,
  input logic rst_n,
  input logic en,
  input logic [1:0] action,
  input logic state,
  input logic [15:0] random,
  input logic [15:0] trans [2:0][1:0][1:0],
  output logic new_state
);

parameter STATE_INIT = 3'b000;
parameter STATE_STOP = 3'b001;

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    state <= STATE_STOP;
  end else if (en) begin
    state <= STATE_INIT;
  end else if (state == STATE_STOP) begin
    state <= STATE_STOP;
  end begin
    state <= state + 1; 
  end
end

always_comb begin
  if (state == STATE_INIT) begin
    new_state = (random < trans[action][state][0]) ? 1'b0 : 1'b1;
  end
end
end

endmodule