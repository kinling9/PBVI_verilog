`timescale 1ns/10ps
`include "step3.sv"

module time_unit;
	initial $timeformat(-9,1," ns",9);
endmodule

module tb_step3;

  logic clk;
  logic rst_n;
  logic en;
  logic [15:0] gamma_action_belief [2:0][15:0][1:0];
  logic [15:0] point_belief [15:0][1:0];
  logic en_loop;
  logic [1:0] point_action [15:0];
  logic [15:0] alpha [15:0][1:0];

  int counter_finish;

  step3 DUT(.*);

  initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    en = 1;
    gamma_action_belief = '{
                           '{
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000},
                            '{16'h0001,16'h0000}
                            },
                           '{
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000},
                            '{16'h0000,16'h0000}
                            },
                           '{
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001},
                            '{16'h0000,16'h0001}
                            }
                           };
    for(int i = 0; i < 16; ++i) begin
        point_belief[i][0]= i*16'h1000;
        point_belief[i][1]=16'hffff-point_belief[i][0];
    end
    #5;
    rst_n = 1'b0;
    #5;
    rst_n = 1'b1;
    #20;
    en = 0;
  end

  initial begin
		forever #20 clk = ! clk;
	end

  always@(posedge clk) begin
		counter_finish = counter_finish + 1;
		
		if(counter_finish == 7) $finish;
	end

  always @(posedge clk) begin
    #5;
    $display("point_action %d : %p\n" ,counter_finish, point_action);
    $display("alpha %d : %p\n" ,counter_finish, alpha);
    $display("en_loop %d : %d\n" ,counter_finish, en_loop);
  end

endmodule