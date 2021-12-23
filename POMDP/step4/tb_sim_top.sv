`timescale 1ns/10ps
//`include "sim_top.sv"

module time_unit;
	initial $timeformat(-9,1," ns",9);
endmodule

module tb_sim_top;

  logic clk;
  logic rst_n;
  logic en;
  logic initial_state;
  logic [15:0] seed0;
  logic [15:0] seed1;
  logic [15:0] alpha [0:15][0:1];
  logic [15:0] vec_reward [0:2][0:1];
  logic [1:0] point_action [0:15];
  logic [15:0] trans [0:2][0:1][0:1];
  logic [15:0] observe [0:2][0:1][0:1];
  logic [15:0] initial_belief [0:1];
  logic [1:0] action;
  logic observation;
  logic cur_state;
  logic [31:0] reward;
  int counter_finish = 0;

  sim_top DUT (.*);

  initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    en = 1'b0;
    seed0 = 16'ha24b;
    seed1 = 16'hc354;
    initial_state = 1'b0;
    observe = '{'{'{16'h8000,16'h8000},'{16'h8000,16'h8000}},
                '{'{16'h8000,16'h8000},'{16'h8000,16'h8000}},
                '{'{55706,9830},'{9830,55706}}};
    trans = '{'{'{16'h8000,16'h8000},'{16'h8000,16'h8000}},
              '{'{16'h8000,16'h8000},'{16'h8000,16'h8000}},
              '{'{16'hffff,16'h0000},'{16'h0000,16'hffff}}};
    alpha = '{'{13464, 20673},'{19082, 20393},'{19216, 20378},'{19262, 20366},
              '{19950, 20102},'{19950, 20102},'{19950, 20102},'{20035, 20035},
              '{20035, 20035},'{20102, 19950},'{20102, 19950},'{20102, 19950},
              '{20366, 19262},'{20378, 19216},'{20393, 19082},'{20673, 13464}};
    vec_reward = '{{7209,0},{0,7209},{6488,6488}};
    point_action = '{1,2,2,2, 2,2,2,2, 2,2,2,2, 2,2,2,0};
    initial_belief = {16'h8000,16'h8000};
  end

  initial begin
		forever #10 clk = ! clk;
	end

  initial begin
    #20;
    rst_n = 1'b0;
    #20;
    rst_n = 1'b1;
  end

  initial begin
    #40;
    en = 1'b1;
    #20;
    en = 1'b0;
  end

  always@(posedge clk) begin
		counter_finish = counter_finish + 1;
		
		if(counter_finish == 200) $finish;
	end

  always @(posedge clk) begin
    #5;
    // $display("nxt state %d : %d\n" ,counter_finish, nxt_state);
    $display("cur state %d : %d" ,counter_finish, cur_state);
    $display("action %d : %d" ,counter_finish, action);
    $display("observation %d : %d" ,counter_finish, observation);
    $display("current reward %d : %d" ,counter_finish, reward);
  end

  initial begin
		// $dumpfile("sim_top.fsdb");
		// $dumpvars(0, sim_top, tb_sim_top, PBVI_decision, PBVI_belief);
	end

endmodule