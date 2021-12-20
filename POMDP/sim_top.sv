module sim_top (
  input logic clk,
  input logic rst_n,
  input logic en,
  input cur_state,
  input logic [15:0] seed,
  input logic [15:0] alpha [15:0][1:0],
  input logic [1:0] point_action [15:0],
  input logic [15:0] trans [2:0][1:0][1:0],
  input logic [15:0] observe [2:0][1:0][1:0],
  input logic [15:0] initial_belief [1:0],
  output logic [1:0] action,
  output logic nxt_state,
  output logic [31:0] reward
);

PBVI_decision mod_decision (
  .clk(clk),
  .rst_n(rst_n),
  .en(),
  .alpha(alpha),
  .point_action(point_action),
  .current_belief(),
  .out_action(action),
  .en_obs()
);

PBVI_belief mod_belief (
  .clk(clk),
  .rst_n(rst_n),
  .en(),
  .trans(trans),
  .observe(observe),
  .current_belief(),
  .action(),
  .observation(),
  .renew_belief(),
  .en_state()
);

obs_gen mod_obs (
  .clk(clk),
  .rst_n(rst_n),
  .en(),
  .cur_state(),
  .action(),
  .random(),
  .observe(observe),
  .observation(),
  .en_belief()
);

state_gen mod_state (
  .clk(clk),
  .rst_n(rst_n),
  .en(en),
  .cur_state(),
  .action(),
  .random(),
  .trans(trans),
  .new_state(),
  .en_next
);

random_gen16 mod_random (
  .clk(clk),
  .rst_n(rst_n),
  .seed(seed),
  .data()
);