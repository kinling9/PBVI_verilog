module obs_gen (
  input logic clk,
  input logic rst_n,
  input logic en,
  input logic cur_state,
  input logic [1:0] action,
  input logic [15:0] random,
  input logic [15:0] observe [0:2][0:1][0:1],
  output logic observation,
  output logic en_belief
);

parameter STATE_INIT = 3'b000;
parameter STATE_STOP = 3'b001;

logic [2:0] state;

// logic [15:0] observe00;
// logic [15:0] observe01;
// logic [15:0] observe10;
// logic [15:0] observe11;
// logic [15:0] observe20;
// logic [15:0] observe21;

// assign observe00 = observe[0][0][0];
// assign observe01 = observe[0][1][0];
// assign observe10 = observe[1][0][0];
// assign observe11 = observe[1][1][0];
// assign observe20 = observe[2][0][0];
// assign observe21 = observe[2][1][0];

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
