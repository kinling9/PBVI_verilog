module PBVI_decision(
  input logic clk,
  input logic rst_n,
  input logic en,
  input logic [15:0] alpha [0:15][0:1],
  input logic [1:0] point_action [0:15],
  input logic [15:0] current_belief [0:1],
  output logic [1:0] out_action,
  output logic en_obs
);

parameter STATE_INIT = 3'b000;
parameter STATE_LEVEL1 = 3'b001;
parameter STATE_LEVEL2 = 3'b010;
parameter STATE_LEVEL3 = 3'b011;
parameter STATE_LEVEL4 = 3'b100;
parameter STATE_STOP = 3'b101;

logic [2:0] state;
logic [31:0] reward [0:15];
logic [3:0] action [0:15];
logic [31:0] sel_reward [0:15];
logic [3:0] sel_action [0:7];

// set the state change
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

// calculate the reward
always_comb begin
  if (state == STATE_INIT) begin
    for(integer i = 0; i < 16; ++i) begin
      reward[i] = current_belief[0] * alpha[i][0] + current_belief[1] * alpha[i][1];
      action[i] = i;
    end
  end
end

always_comb begin
  case(state)
    // initial state : get the value from the inital reward
    STATE_LEVEL1: begin
      for(int i = 0; i < 8; ++i) begin
        sel_reward[i] <= (reward[2*i] >= reward[2*i+1]) ? reward[2*i] : reward[2*i+1];
        sel_action[i] <= (reward[2*i] >= reward[2*i+1]) ? action[2*i] : action[2*i+1];
      end
    end
    STATE_LEVEL2: begin
      for(int i = 0; i < 4; ++i) begin
        sel_reward[i] <= (sel_reward[2*i] >= sel_reward[2*i+1]) ? sel_reward[2*i] : sel_reward[2*i+1];
        sel_action[i] <= (sel_reward[2*i] >= sel_reward[2*i+1]) ? sel_action[2*i] : sel_action[2*i+1];
      end
    end
    STATE_LEVEL3: begin
      for(int i = 0; i < 2; ++i) begin
        sel_reward[i] <= (sel_reward[2*i] >= sel_reward[2*i+1]) ? sel_reward[2*i] : sel_reward[2*i+1];
        sel_action[i] <= (sel_reward[2*i] >= sel_reward[2*i+1]) ? sel_action[2*i] : sel_action[2*i+1];
      end
    end
    STATE_LEVEL4: begin
      for(int i = 0; i < 1; ++i) begin
        sel_reward[i] <= (sel_reward[2*i] >= sel_reward[2*i+1]) ? sel_reward[2*i] : sel_reward[2*i+1];
        sel_action[i] <= (sel_reward[2*i] >= sel_reward[2*i+1]) ? sel_action[2*i] : sel_action[2*i+1];
      end
      en_obs = 1'b1;
    end
    default: begin
      for(int i = 0; i < 16; ++i) begin
        sel_reward[i] <= 16'b0;
        sel_action[i] <= sel_action[i];
      end
      en_obs = 1'b0;
    end
  endcase
end

always_comb begin
  if (state == STATE_STOP) begin
    out_action = point_action[sel_action[0]];
  end
end

endmodule