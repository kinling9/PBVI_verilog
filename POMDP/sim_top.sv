`include "PBVI_decision.sv"
`include "PBVI_belief.sv"
`include "obs_gen.sv"
`include "state_gen.sv"
`include "random_gen16.sv"

module sim_top (
  input logic clk,
  input logic rst_n,
  input logic en,
  input initial_state,
  input logic [15:0] seed0,
  input logic [15:0] seed1,
  input logic [15:0] alpha [15:0][1:0],
  input logic [15:0] vec_reward [2:0][1:0],
  input logic [1:0] point_action [15:0],
  input logic [15:0] trans [2:0][1:0][1:0],
  input logic [15:0] observe [2:0][1:0][1:0],
  input logic [15:0] initial_belief [1:0],
  output logic [1:0] action,
  output logic nxt_state,
  output logic [31:0] reward
);



parameter STATE_INIT = 3'b000;
// parameter STATE_LEVELT = 3'b001;
// parameter STATE_LEVELO = 3'b010;
// parameter STATE_LEVELN = 3'b011;
parameter STATE_STOP = 3'b001;

logic [2:0] state;
logic en_decision;
logic en_belief_out;
logic cur_state;
logic out_state;
logic [15:0] current_belief [1:0];
logic [15:0] out_belief [1:0];
logic [15:0] out_random0;
logic [15:0] out_random1;
logic [15:0] out_reward;
logic observation;
logic en_trans;
logic en_belief;
logic en_calculate;

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
    en_decision = 1'b1;
    cur_state = initial_state;
    current_belief = initial_belief;
  end else begin
    en_decision = en_belief_out;
    cur_state = out_state;
    current_belief = out_belief;
  end
end

always_ff @(posedge clk) begin
  if (state == STATE_INIT) begin
    reward <= 32'b0;
  end else if (en_calculate) begin
    reward <= reward + out_reward;
  end
end


PBVI_decision mod_decision (
  .clk(clk),
  .rst_n(rst_n),
  .en(en_decision),
  .alpha(alpha),
  .point_action(point_action),
  .current_belief(),
  .out_action(action),
  .en_obs(en_trans)
);

PBVI_belief mod_belief (
  .clk(clk),
  .rst_n(rst_n),
  .en(en_belief),
  .trans(trans),
  .observe(observe),
  .current_belief(current_belief),
  .action(action),
  .observation(observation),
  .renew_belief(out_belief),
  .en_decision(en_belief_out)
);

obs_gen mod_obs (
  .clk(clk),
  .rst_n(rst_n),
  .en(en_trans),
  .cur_state(cur_state),
  .action(action),
  .random(out_random0),
  .observe(observe),
  .observation(observation),
  .en_belief(en_belief)
);

state_gen mod_state (
  .clk(clk),
  .rst_n(rst_n),
  .en(en_trans),
  .cur_state(cur_state),
  .action(action),
  .vec_reward(vec_reward),
  .random(out_random1),
  .trans(trans),
  .out_reward(out_reward),
  .new_state(out_state),
  .en_calculate(en_calculate)
);

random_gen16 mod_random0 (
  .clk(clk),
  .rst_n(rst_n),
  .seed(seed0),
  .data(out_random0)
);

random_gen16 mod_random1 (
  .clk(clk),
  .rst_n(rst_n),
  .seed(seed1),
  .data(out_random1)
);

endmodule