module state_gen (
  input logic clk,
  input logic rst_n,
  input logic en,
  input logic cur_state,
  input logic [1:0] action,
  input logic [15:0] random,
  input logic [15:0] vec_reward [0:2][0:1],
  input logic [15:0] trans [0:2][0:1][0:1],
  output logic [15:0] out_reward,
  output logic new_state,
  output logic en_calculate
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
    new_state = (random < trans[action][cur_state][0]) ? 1'b0 : 1'b1;
    out_reward = vec_reward[action][cur_state];
    en_calculate = 1'b1;
  end else if (state == STATE_STOP) begin
    en_calculate = 1'b0;
  end
end

endmodule