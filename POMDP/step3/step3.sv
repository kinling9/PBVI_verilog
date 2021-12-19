module step3 (
  input logic clk,
  input logic rst_n,
  input logic en,
  input logic [15:0] gamma_action_bilief[1:0][15:0][1:0],
  input logic [15:0] point_belief[15:0][1:0],
  output logic [1:0] point_action[15:0]
  output logic [15:0] alpha[15:0][1:0]
);

parameter STATE_INIT = 3'b000;
parameter STATE_LEVEL1 = 3'b001;
parameter STATE_LEVEL2 = 3'b010;
//parameter STATE_LEVEL3 = 3'b011;
//parameter STATE_LEVEL4 = 3'b100;
parameter STATE_STOP = 3'b011;

logic [2:0] state;
logic [32:0] val[15:0];
logic [32:0] max_val[15:0];

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    state <= STATE_STOP;
  end else if (en) begin
    state <= STATE_INIT;
  end else if (state == STATE_STOP) begin
    state <= STATE_STOP;
  end begin
    state <= state + 1; 
  end
end

always_comb begin
  if (state == STATE_INIT) begin
    for(unsigned int i = 0; i < 16; ++i) begin
        val[i]=point_belief[i][0]*gamma_action_belief[0][i][0]+point_belief[i][1]*gamma_action_belief[0][i][1];
        max_val[i]=val[i];
        alpha[i]=gamma_action_belief[0][i];
        point_action[i]=2'b00;
     end
  end
end

always_comb begin
  case (state)
   STATE_LEVEL1: begin
     for(unsigned int i = 0; i < 16; ++i) begin
        val[i]=point_belief[i][0]*gamma_action_belief[1][i][0]+point_belief[i][1]*gamma_action_belief[1][i][1];
        if(val[i]>max_val[i]) begin
         max_val[i]=val[i];
         alpha[i]=gamma_action_belief[1][i];
         point_action[i]=2'b01;
        end
     end
   end
   STATE_LEVEL2: begin
     for(unsigned int i = 0; i < 16; ++i) begin
        val[i]=point_belief[i][0]*gamma_action_belief[2][i][0]+point_belief[i][1]*gamma_action_belief[2][i][1];
        if(val[i]>max_val[i]) begin
         max_val[i]=val[i];
         alpha[i]=gamma_action_belief[2][i];
         point_action[i]=2'b10;
        end
     end
   end
   default: begin
      for(unsigned int i = 0; i < 16; ++i) begin
        val[i] <= 33'b0;
        max_val[i] <= 33'b0;
        alpha[i]=alpha[i];
        point_action[i]=point_action[i];
      end
    end
  endcase
end

endmodule