module obs_gen (
  input logic clk,
  input logic rst_n,
  input logic en,
  input logic cur_state,
  input logic [1:0] action,
  input logic [15:0] random,
  input logic [15:0] observe [2:0][1:0][1:0],
  output logic observation,
  output logic en_belief
);

parameter STATE_INIT = 3'b000;
parameter STATE_STOP = 3'b001;

logic [2:0] state;

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    state <= STATE_STOP;
  end else if (en) begin
    state <= STATE_INIT;
  end else if (state == STATE_STOP) begin
    state <= STATE_STOP;
  end else begin
    state <= state + 1; 
  end
end

always_comb begin
  if (state == STATE_INIT) begin
    observation = (random < observe[action][cur_state][0]) ? 1'b0 : 1'b1;
    en_belief = 1'b1;
  end else if (state == STATE_STOP) begin
    en_belief = 1'b0;
  end
end

endmodule
