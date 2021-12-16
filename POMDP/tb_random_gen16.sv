`timescale 1ns/10ps
`include "random_gen16.sv"

module time_unit;
	initial $timeformat(-9,1," ns",9);
endmodule

module tb_test;

  logic clk;
  logic rst_n;
  logic [15:0] seed;
  logic [15:0] data;

  int counter_finish;

  random_gen16 DUT(
    .clk(clk),
    .rst_n(rst_n),
    .seed(seed),
    .data(data)
  );

  initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    seed = 16'd123;
    #5;
    rst_n = 1'b0;
    #5;
    rst_n = 1'b1;
  end

  initial begin
		#20;
		forever #20 clk = ! clk;
	end

  always@(posedge clk) begin
		counter_finish = counter_finish + 1;
		
		if(counter_finish == 30) $finish;
	end

  always @(posedge clk) begin
    #5;
    $display("random %d : %d" ,counter_finish, data);
  end
endmodule
