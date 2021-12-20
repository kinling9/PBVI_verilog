module PBVI_belief (
  input logic clk,
  input logic rst_n,
  input logic en,
  input logic [15:0] trans [0:2][0:1][0:1],
  input logic [15:0] observe [0:2][0:1][0:1],
  input logic [15:0] current_belief [0:1],
  input logic [1:0] action,
  input logic observation,
  output logic [15:0] renew_belief [0:1],
  output logic en_decision
);

parameter STATE_INIT = 3'b000;
parameter STATE_WAIT = 3'b001;
// parameter STATE_LEVELO = 3'b010;
// parameter STATE_LEVELN = 3'b011;
parameter STATE_STOP = 3'b010;

logic [2:0] state;
logic [31:0] t_belief [0:1];
logic [31:0] o_belief [0:1];
// logic [15:0] n_belief [1:0];
logic [31:0] belief_total;

// logic [15:0] current_belief0;
// logic [15:0] current_belief1;

// assign current_belief0 = current_belief[0];
// assign current_belief1 = current_belief[1];

// logic [31:0] t_belief0;
// logic [31:0] t_belief1;

// assign t_belief0 = t_belief[0];
// assign t_belief1 = t_belief[1];

// logic [31:0] o_belief0;
// logic [31:0] o_belief1;

// assign o_belief0 = o_belief[0];
// assign o_belief1 = o_belief[1];

// logic [15:0] renew_belief0;
// logic [15:0] renew_belief1;

// assign renew_belief0 = renew_belief[0];
// assign renew_belief1 = renew_belief[1];

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
  case(state)
  STATE_INIT: begin
    for (int i = 0; i < 2; ++i) begin
      t_belief[i] = trans[action][0][i] * current_belief[0] + trans[action][1][i] * current_belief[1];
      o_belief[i] = observe[action][i][observation] * (t_belief[i] >> 16);
    end
    belief_total = o_belief[0] + o_belief[1];
    for (int i = 0; i < 2; ++i) begin
      renew_belief[i] = o_belief[i] / (belief_total >> 16);
    end
    en_decision = 1'b1;
  end
  STATE_WAIT: begin
    en_decision = 1'b1;
  end
  default: begin
    belief_total = 16'b0;
    for (int i = 0; i < 2; ++i) begin
      t_belief[i] = 16'b0;
      o_belief[i] = 16'b0;
      renew_belief[i] = renew_belief[i];
    end
    en_decision = 1'b0;
  end
  endcase  
end

endmodule