module whole_flow (
  input logic clk,
  input logic rst_n,
  input logic en,
  input logic [15:0] max_iter,
  input logic [15:0] discount,
  input logic [15:0] alpha_in [0:15][0:1],
  input logic [15:0] vec_reward [0:2][0:1],
  input logic [15:0] trans [0:2][0:1][0:1],
  input logic [15:0] observe [0:2][0:1][0:1],
  input initial_state,
  input logic [15:0] seed0,
  input logic [15:0] seed1,
  input logic [15:0] initial_belief [0:1],
  output logic [1:0] action,
  output logic observation,
  output logic cur_state,
  output logic [31:0] reward
);


logic en_solved;
logic [1:0] point_action [0:15];
logic [15:0] alpha_out [0:15][0:1];

solve_pbvi mod_solve_pbvi (
  .clk(clk),
  .rst_n(rst_n),
  .en(en),
  .max_iter(max_iter),
  .discount(discount),
  .alpha_in(alpha_in),
  .vec_reward(vec_reward),
  .trans(trans),
  .observe(observe),
  .en_solved(en_solved),
  .point_action(point_action),
  .alpha_out(alpha_out)
);
sim_top mod_sim_top(
  .clk(clk),
  .rst_n(rst_n),
  .en(en_solved),
  .initial_state(initial_state),
  .seed0(seed0),
  .seed1(seed1),
  .alpha(alpha_out),
  .vec_reward(vec_reward),
  .point_action(point_action),
  .trans(trans),
  .observe(observe),
  .initial_belief(initial_belief),
  .action(action),
  .observation(observation),
  .cur_state(cur_state),
  .reward(reward)
);
endmodule