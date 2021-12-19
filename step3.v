module step3 (clk,en,action);
parameter num_s=2;
parameter num_b=16;
input clk;
input en;
output reg[1:0] action;
integer i;
reg[32:0] temp;
reg[32:0] V_b[num_b-1:0];
reg[15:0] s0_b[num_b-1:0];
reg[15:0] s1_b[num_b-1:0];
reg[15:0] best_gamma_b_s0;
reg[15:0] best_gamma_b_s1;
reg[15:0] gamma_a1_b_s0[num_b-1:0];
reg[15:0] gamma_a2_b_s0[num_b-1:0];
reg[15:0] gamma_a3_b_s0[num_b-1:0];
reg[15:0] gamma_a1_b_s1[num_b-1:0];
reg[15:0] gamma_a2_b_s1[num_b-1:0];
reg[15:0] gamma_a3_b_s1[num_b-1:0];
reg[15:0] alpha_vector_b_s0[num_b-1:0];
reg[15:0] alpha_vector_b_s1[num_b-1:0];

initial 
begin
    best_gamma_b_s0=0;
    best_gamma_b_s1=0;
    temp=0;
    action=0;
    for(i=0;i<num_b;i=i+1)
    begin
        V_b[i]=0;
        gamma_a1_b_s0[i]=1;
        gamma_a2_b_s0[i]=2;
        gamma_a3_b_s0[i]=3;
        gamma_a1_b_s1[i]=1;
        gamma_a2_b_s1[i]=2;
        gamma_a3_b_s1[i]=3;
        alpha_vector_b_s0[i]=0;
        alpha_vector_b_s1[i]=0;
    end
end

always @(posedge clk)
if (en)
begin
     for(i=0;i<num_b;i=i+1)
     begin
         temp=s0_b[i]*gamma_a1_b_s0[i]+s1_b[i]*gamma_a1_b_s1[i];
         if (temp>V_b[i])
           V_b[i]=temp;
           alpha_vector_b_s0[i]=gamma_a1_b_s0[i];
           alpha_vector_b_s1[i]=gamma_a1_b_s1[i];
           action=2'b01;
     end
     for(i=0;i<num_b;i=i+1)
     begin
         temp=s0_b[i]*gamma_a2_b_s0[i]+s1_b[i]*gamma_a2_b_s1[i];
         if (temp>V_b[i])
           V_b[i]=temp;
           alpha_vector_b_s0[i]=gamma_a2_b_s0[i];
           alpha_vector_b_s1[i]=gamma_a2_b_s1[i];
           action=2'b10;
     end  
     for(i=0;i<num_b;i=i+1)
     begin
         temp=s0_b[i]*gamma_a3_b_s0[i]+s1_b[i]*gamma_a3_b_s1[i];
         if (temp>V_b[i])
           V_b[i]=temp;
           alpha_vector_b_s0[i]=gamma_a3_b_s0[i];
           alpha_vector_b_s1[i]=gamma_a3_b_s1[i];
           action=2'b11;
     end  
end
endmodule