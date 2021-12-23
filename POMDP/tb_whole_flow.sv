`timescale 1ns/10ps
`include "step1.sv"

module time_unit;
	initial $timeformat(-9,1," ns",9);
endmodule

module tb_whole_flow;

  logic clk;
  logic rst_n;
  logic en;
  logic [15:0] max_iter;
  logic [15:0] discount;
  logic [15:0] alpha_in [0:15][0:1];
  logic [15:0] vec_reward [0:2][0:1];
  logic [15:0] trans [0:2][0:1][0:1];
  logic [15:0] observe [0:2][0:1][0:1];
  logic [1:0] point_action [0:15];
  //logic [15:0] alpha_out [0:15][0:1];
  int counter_finish = 0;

  logic initial_state;
  logic [15:0] seed0;
  logic [15:0] seed1;
  logic [15:0] initial_belief [0:1];
  logic [1:0] action;
  logic observation;
  logic cur_state;
  logic [31:0] reward;

  whole_flow DUT (.*);

  initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    en = 1'b0;
    max_iter = 16'd5;
    discount = 16'hc000;
    observe = '{'{'{16'h8000,16'h8000},'{16'h8000,16'h8000}},
                '{'{16'h8000,16'h8000},'{16'h8000,16'h8000}},
                '{'{55706,9830},'{9830,55706}}};
    trans = '{'{'{16'h8000,16'h8000},'{16'h8000,16'h8000}},
              '{'{16'h8000,16'h8000},'{16'h8000,16'h8000}},
              '{'{16'hffff,16'h0001},'{16'h0001,16'hffff}}};
    // alpha_in = '{'{13464, 20673},'{19082, 20393},'{19216, 20378},'{19262, 20366},
    //           '{19950, 20102},'{19950, 20102},'{19950, 20102},'{20035, 20035},
    //           '{20035, 20035},'{20102, 19950},'{20102, 19950},'{20102, 19950},
    //           '{20366, 19262},'{20378, 19216},'{20393, 19082},'{20673, 13464}};
    alpha_in = '{'{0, 0},'{0, 0},'{0, 0},'{0, 0},
               '{0, 0},'{0, 0},'{0, 0},'{0, 0},
               '{0, 0},'{0, 0},'{0, 0},'{0, 0},
               '{0, 0},'{0, 0},'{0, 0},'{0, 0}};
    vec_reward = '{{7209,0},{0,7209},{6488,6488}};
    initial_belief = {16'h8000,16'h8000};
    seed0 = 16'ha24b;
    seed1 = 16'hc354;
    initial_state = 1'b0;

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
    #60;
    en = 1'b1;
    #20;
    en = 1'b0;
  end

  always@(posedge clk) begin
		counter_finish = counter_finish + 1;
		if (counter_finish == 150) begin
      $finish;
    end
	end

endmodule