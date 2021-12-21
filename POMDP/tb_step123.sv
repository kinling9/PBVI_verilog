`timescale 1ns/10ps
`include "step1.sv"

module time_unit;
	initial $timeformat(-9,1," ns",9);
endmodule

module tb_step123;

  logic clk;
  logic rst_n;
  logic en;
  logic [15:0] discount;
  logic [15:0] alpha_in [0:15][0:1];
  logic [15:0] vec_reward [0:2][0:1];
  logic [15:0] trans [0:2][0:1][0:1];
  logic [15:0] observe [0:2][0:1][0:1];
  logic en_loop;
  logic [1:0] point_action [0:15];
  logic [15:0] alpha_out [0:15][0:1];
  int counter_finish = 0;

  step123 DUT (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .discount(discount),
    .alpha_in(alpha_in),
    .vec_reward(vec_reward),
    .trans(trans),
    .observe(observe),
    .en_loop(en_loop),
    .point_action(point_action),
    .alpha_out(alpha_out)
  );

  initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    en = 1'b0;
    discount = 16'hc000;
    observe = '{'{'{16'h8000,16'h8000},'{16'h8000,16'h8000}},
                '{'{16'h8000,16'h8000},'{16'h8000,16'h8000}},
                '{'{55706,9830},'{9830,55706}}};
    trans = '{'{'{16'h8000,16'h8000},'{16'h8000,16'h8000}},
              '{'{16'h8000,16'h8000},'{16'h8000,16'h8000}},
              '{'{16'hffff,16'h0000},'{16'h0000,16'hffff}}};
    alpha_in = '{'{13464, 20673},'{19082, 20393},'{19216, 20378},'{19262, 20366},
              '{19950, 20102},'{19950, 20102},'{19950, 20102},'{20035, 20035},
              '{20035, 20035},'{20102, 19950},'{20102, 19950},'{20102, 19950},
              '{20366, 19262},'{20378, 19216},'{20393, 19082},'{20673, 13464}};
    vec_reward = '{{7209,0},{0,7209},{6488,6488}};

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
		if (counter_finish == 30) begin
      $finish;
    end
	end

endmodule