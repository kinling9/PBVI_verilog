module step3 (clk,action)
parameter num_s=2
parameter num_b=100;
input clk;
output action;
reg V;
reg[15:0] s0_b[num_b-1,0];
reg[15:0] s1_b[num_b-1,0];
reg[15:0] gamma_a1_b_s0[num_b-1,0];
reg[15:0] gamma_a2_bs_s0[num_b-1,0];
reg[15:0] gamma_a3_b_s0[num_b-1,0];
reg[15:0] gamma_a1_b_s1[num_b-1,0];
reg[15:0] gamma_a2_bs_s1[num_b-1,0];
reg[15:0] gamma_a3_b_s1[num_b-1,0];

always@ (posedge clk)
begin
     
end