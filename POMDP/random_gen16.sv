module random_gen16
  (
  input logic       clk,
  input logic       rst_n,
  input logic [15:0] seed,
  output logic [15:0] data
  );

// 16-bit LFSR generate with a user specified seed
	parameter BITS = 16;	

  logic [15:0] data_next;
  always_comb begin
    data_next = data;
    repeat(BITS) begin
      data_next = {(data_next[15]^data_next[14]^data_next[12]^data_next[4]), data_next[15:1]};
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      data <= seed;
    else
      data <= data_next;
  end
endmodule
