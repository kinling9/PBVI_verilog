module step2 (
  input logic clk,
  input logic rst_n,
  input logic en,
  input logic [15:0] gamma_intermediate_action_observation_alpha [0:2][0:1][0:15][0:1],
  input logic [15:0] gamma_reward_action [0:2][0:1],
  input logic [15:0] point_belief [0:15][0:1],
  output logic en_step3,
  output logic [15:0] gamma_action_bilief [0:2][0:15][0:1]
);

parameter STATE_INIT = 3'b000;
parameter STATE_LEVEL1 = 3'b001;
parameter STATE_LEVEL2 = 3'b010;
parameter STATE_LEVEL3 = 3'b011;
parameter STATE_LEVEL4 = 3'b100;
parameter STATE_STOP = 3'b101;

logic [2:0] state;
logic [15:0] gamma_intermediate_dot_point_belief [0:2][0:1][0:15][0:15];
logic [15:0] sel_dot [0:2][0:1][0:15][0:15];
logic [3:0] alpha_idx [0:2][0:1][0:15][0:15];
logic [3:0] sel_alpha_idx [0:2][0:1][0:15][0:15];

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
    for(int i = 0; i < 16; ++i) begin
        for(int j = 0; j < 16; ++j) begin
            for(int k = 0; k < 2; ++k) begin
                for(int l = 0; l<3; ++l) begin
                    gamma_intermediate_dot_point_belief[l][k][j][i] =
                    gamma_intermediate_action_observation_alpha[l][k][j][0]*point_belief[i][0] +
                    gamma_intermediate_action_observation_alpha[l][k][j][1]*point_belief[i][1];
                    alpha_idx[l][k][j][i]= j;
                end
            end
        end
     end
  end
end

always_comb begin
  case(state)
    STATE_LEVEL1: begin
      for(int i = 0; i < 16; ++i) begin
        for(int j = 0; j < 8; ++j) begin
            for(int k=0; k < 2; ++k) begin
                for(int l=0; l < 3; ++l) begin
                    sel_dot[l][k][j][i] = 
                    (gamma_intermediate_dot_point_belief[l][k][2*j][i] >= 
                     gamma_intermediate_dot_point_belief[l][k][2*j+1][i]) ?
                     gamma_intermediate_dot_point_belief[l][k][2*j][i] :
                     gamma_intermediate_dot_point_belief[l][k][2*j+1][i];
                    sel_alpha_idx[l][k][j][i] =
                    (gamma_intermediate_dot_point_belief[l][k][2*j][i] >= 
                     gamma_intermediate_dot_point_belief[l][k][2*j+1][i]) ?
                     alpha_idx[l][k][2*j][i] :
                     alpha_idx[l][k][2*j+1][i];
                end
            end
        end
      end
    end
    STATE_LEVEL2: begin
      for(int i = 0; i < 16; ++i) begin
        for(int j = 0; j < 4; ++j) begin
            for(int k=0; k < 2; ++k) begin
                for(int l=0; l < 3; ++l) begin
                    sel_dot[l][k][j][i] = 
                    (sel_dot[l][k][2*j][i] >= 
                     sel_dot[l][k][2*j+1][i]) ?
                     sel_dot[l][k][2*j][i] :
                     sel_dot[l][k][2*j+1][i];
                    sel_alpha_idx[l][k][j][i] =
                    (sel_dot[l][k][2*j][i] >= 
                     sel_dot[l][k][2*j+1][i]) ?
                     sel_alpha_idx[l][k][2*j][i] :
                     sel_alpha_idx[l][k][2*j+1][i];
                end
            end
        end
      end
    end
    STATE_LEVEL3: begin
      for(int i = 0; i < 16; ++i) begin
        for(int j = 0; j < 2; ++j) begin
            for(int k=0; k < 2; ++k) begin
                for(int l=0; l < 3; ++l) begin
                    sel_dot[l][k][j][i] = 
                    (sel_dot[l][k][2*j][i] >= 
                     sel_dot[l][k][2*j+1][i]) ?
                     sel_dot[l][k][2*j][i] :
                     sel_dot[l][k][2*j+1][i];
                    sel_alpha_idx[l][k][j][i] =
                    (sel_dot[l][k][2*j][i] >= 
                     sel_dot[l][k][2*j+1][i]) ?
                     sel_alpha_idx[l][k][2*j][i] :
                     sel_alpha_idx[l][k][2*j+1][i];
                end
            end
        end
      end
    end
    STATE_LEVEL4: begin
      for(int i = 0; i < 16; ++i) begin
        for(int j = 0; j < 1; ++j) begin
            for(int k=0; k < 2; ++k) begin
                for(int l=0; l < 3; ++l) begin
                    sel_dot[l][k][j][i] = 
                    (sel_dot[l][k][2*j][i] >= 
                     sel_dot[l][k][2*j+1][i]) ?
                     sel_dot[l][k][2*j][i] :
                     sel_dot[l][k][2*j+1][i];
                    sel_alpha_idx[l][k][j][i] =
                    (sel_dot[l][k][2*j][i] >= 
                     sel_dot[l][k][2*j+1][i]) ?
                     sel_alpha_idx[l][k][2*j][i] :
                     sel_alpha_idx[l][k][2*j+1][i];
                end
            end
        end
      end
    end 
    default: begin
      for(int i = 0; i < 16; ++i) begin
        for(int j = 0; j<16; ++j) begin
            for(int k = 0; k<2; ++k) begin
                for(int l = 0; l<3; ++l) begin
                    sel_dot[l][k][j][i] = 16'b0;
                    sel_alpha_idx[l][k][j][i]= sel_alpha_idx[l][k][j][i];
                end
            end
        end
      end
    end
  endcase
end

always_comb begin
  if (state == STATE_STOP) begin
    for(int i = 0; i < 16; ++i) begin
      for(int l = 0; l < 3; ++l) begin
        for(int s = 0; s < 2; ++s) begin
          gamma_action_bilief[l][i][s] = 
          gamma_reward_action[l][s] +
          gamma_intermediate_action_observation_alpha[l][0][sel_alpha_idx[l][0][0][i]][s] +
          gamma_intermediate_action_observation_alpha[l][1][sel_alpha_idx[l][1][0][i]][s];
        end
      end
    end
  end
end

always_comb begin
  if (state == STATE_LEVEL4) begin
    en_step3 = 1'b1;
  end else if (state == STATE_STOP) begin
    en_step3 = 1'b0;
  end
end

endmodule