module step123 (
  input logic clk,
  input logic rst_n,
  input logic en,
  input logic [15:0] discount,
  input logic [15:0] alpha_in [0:15][0:1],
  input logic [15:0] vec_reward [0:2][0:1],
  input logic [15:0] trans [0:2][0:1][0:1],
  input logic [15:0] observe [0:2][0:1][0:1],
  output logic en_loop,
  output logic [1:0] point_action [0:15],
  output logic [15:0] alpha_out [0:15][0:1]
);

// parameter STATE_INIT = 3'b000;
// parameter STATE_WAIT = 3'b001;
// parameter STATE_STOP = 3'b010;

//logic state;
logic en_step2;
logic en_step3;
logic [15:0] gamma_intermediate_action_observation_alpha [0:2][0:1][0:15][0:1];
logic [15:0] point_belief [0:15][0:1];
logic [15:0] gamma_action_belief [0:2][0:15][0:1];

// always_ff @(posedge clk or negedge rst_n) begin
//   if(!rst_n) begin
//     state <= STATE_STOP;
//   end else if (en) begin
//     state <= STATE_INIT;
//   end else if (state == STATE_STOP) begin
//     state <= STATE_STOP;
//   end else begin
//     state <= state + 1; 
//   end
// end

always_comb begin : gen_point_belief
  for(int i = 0; i < 16; ++i) begin
    point_belief[i][0] = i*16'h1000 + 16'h800;
    point_belief[i][1] = 16'hffff - point_belief[i][0] + 1;
  end
end
step1 mod_step1(
  .clk(clk),
  .rst_n(rst_n),
  .en(en),
  .discount(discount),
  .alpha(alpha_in),
  .trans(trans),
  .observe(observe),
  .en_step2(en_step2),
  .gamma_intermediate_action_observation_alpha(gamma_intermediate_action_observation_alpha)
);

step2 mod_step2(
  .clk(clk),
  .rst_n(rst_n),
  .en(en_step2),
  .gamma_intermediate_action_observation_alpha(gamma_intermediate_action_observation_alpha),
  .gamma_reward_action(vec_reward),
  .point_belief(point_belief),
  .en_step3(en_step3),
  .gamma_action_belief(gamma_action_belief)
);

step3 mod_step3(
  .clk(clk),
  .rst_n(rst_n),
  .en(en_step3),
  .gamma_action_belief(gamma_action_belief),
  .point_belief(point_belief),
  .en_loop(en_loop),
  .point_action(point_action),
  .alpha(alpha_out)
);
endmodule