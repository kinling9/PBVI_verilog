module step3 
#(
  parameter num_s=2,
  parameter num_a=3,
  parameter num_b=16,
  parameter a1_tag=0,
  parameter a2_tag=16,
  parameter a3_tag=32
  )
 (
  clk,
  en,
  );

input clk;
input en;

//best av.action for every belief; num:num_b; dim:1
reg[1:0] best_a_b[num_b-1:0];
//best av.v for every belief point; num:num_b; dim:num_s
reg[15:0] best_gamma_b_s0[num_b-1:0];
reg[15:0] best_gamma_b_s1[num_b-1:0];


integer i;
integer j;
reg[32:0] val;
reg[32:0] max_val;

//belief points; num:num_b; dim:num_s
reg[15:0] b_s0[num_b-1:0];
reg[15:0] b_s1[num_b-1:0];
//alpha_vectors; num:num_b*num_a; dim:num_s
reg[15:0] gamma_a_b_s0[num_a*num_b-1:0];
reg[15:0] gamma_a_b_s1[num_a*num_b-1:0];



initial 
begin
    val=0;
    max_val=0;
    for(i=0;i<num_b;i=i+1)
    begin
        best_a_b[i]=0;
        best_gamma_b_s0[i]=0;
        best_gamma_b_s1[i]=0;

        b_s0[i]=16'h0000+i*16'h1000;
        b_s1[i]=16'hffff-b_s0[i];

        gamma_a_b_s0[a1_tag+i]=16'h0001;
        gamma_a_b_s0[a2_tag+i]=16'h0002;
        gamma_a_b_s0[a3_tag+i]=16'h0003;
        gamma_a_b_s1[a1_tag+i]=16'h0003;
        gamma_a_b_s1[a2_tag+i]=16'h0002;
        gamma_a_b_s1[a3_tag+i]=16'h0001;
    end
end

always @(posedge clk)
if (en)
begin
     for(i=0;i<num_b;i=i+1)
     begin
         max_val=0;
         best_a_b[i]=0;
         for(j=0;j<num_a;j=j+1)
         begin
            val=b_s0[i]*gamma_a_b_s0[j*num_b+i]+b_s1[i]*gamma_a_b_s1[j*num_b+i];
            if (!best_a_b[i] || val>max_val)
            begin
                max_val=val;
                best_a_b[i]=j+1;
                best_gamma_b_s0[i]=gamma_a_b_s0[j*num_b+i];
                best_gamma_b_s1[i]=gamma_a_b_s1[j*num_b+i];
            end
         end
     end
end
endmodule