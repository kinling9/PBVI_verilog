module step1 (
  input logic clk,
  input logic rst_n,
  input logic en,
  input logic [15:0] discount,
  input logic [15:0] alpha [0:15][0:1],
  input logic [15:0] trans [0:2][0:1][0:1],
  input logic [15:0] observe [0:2][0:1][0:1],
  output logic en_step2,
  output logic [15:0] gamma_intermediate_action_observation_alpha [0:2][0:1][0:15][0:1]
);
parameter STATE_INIT = 1'b0;
parameter STATE_STOP = 1'b1;

logic state;
logic [63:0] gamma_intermediate [0:2][0:1][0:15][0:1];
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
    for(int i = 0; i < 2; ++i) begin
      for(int j = 0; j < 16; ++j) begin
        for(int k=0; k < 2; ++k) begin
          for(int l=0; l < 3; ++l) begin
            gamma_intermediate[l][k][j][i] = 
            ((trans[l][i][0]*observe[l][k][0]*alpha[j][0] + trans[l][i][1]*observe[l][k][1]*alpha[j][1])*discount);
            gamma_intermediate_action_observation_alpha[l][k][j][i] = gamma_intermediate[l][k][j][i][63-:16];
          end
        end
      end
    end
  end
end

always_comb begin
  if (state == STATE_INIT) begin
    en_step2 = 1'b1;
  end else if (state == STATE_STOP) begin
    en_step2 = 1'b0;
  end
end

endmodule