`timescale 1ns/10ps
`include "obs_gen.sv"

module time_unit;
	initial $timeformat(-9,1," ns",9);
endmodule

module tb_obs_gen;

  logic clk;
  logic rst_n;
  logic en;
  logic [1:0] action;
  logic [15:0] random;
  logic [15:0] observe [0:2][0:1][0:1];
  logic observation;
  logic en_belief;

  int counter_finish;

  obs_gen DUT(.*);

  // obs_gen DUT(
  //   .clk(clk),
  //   .rst_n(rst_n),
  //   .en(en),
  //   .action(action),
  //   .state(state),
  //   .random(random),
  //   .observe(observe),
  //   .observation(observation),
  //   .en_belief(en_belief)
  // );

  initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    random = 16'h9000;
    action = 2'b10;
    observe = '{'{{16'h8000,16'h8000},{16'h8000,16'h8000}},
                '{{16'h8000,16'h8000},{16'h8000,16'h8000}},
                '{{16'h8000,16'h8000},{16'h8000,16'h8000}}};
    en = 1;
    #45;
    rst_n = 1'b0;
    #5;
    rst_n = 1'b1;
    #40;
    en = 0;
  end

  initial begin
		#20;
		forever #20 clk = ! clk;
	end

  always@(posedge clk) begin
		counter_finish = counter_finish + 1;
		
		if(counter_finish == 10) $finish;
	end

  always @(posedge clk) begin
    #5;
    $display("obs %d : %d\n" ,counter_finish, observation);
    $display("en_belief %d : %d\n" ,counter_finish, en_belief);
  end

  initial begin
		$dumpfile("obs_gen.fsdb");
		$dumpvars(0, obs_gen, tb_obs_gen);
	end

endmodule