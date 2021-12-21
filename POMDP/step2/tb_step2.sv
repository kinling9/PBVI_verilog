`timescale 1ns/10ps
`include "step2.sv"

module time_unit;
	initial $timeformat(-9,1," ns",9);
endmodule

module tb_step2;

  logic clk;
  logic rst_n;
  logic en;
  logic [15:0] gamma_intermediate_action_observation_alpha [0:2][0:1][0:15][0:1];
  logic [15:0] gamma_reward_action [0:2][0:1];
  logic [15:0] point_belief [0:15][0:1];
  logic en_step3;
  logic [15:0] gamma_action_belief [0:2][0:15][0:1];

  int counter_finish;

  step2 DUT(.*);

  initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    en = 1;
    gamma_intermediate_action_observation_alpha = '{
                                                    '{//action 0
                                                      '{//action 0; observation 0
                                                      '{16'hffff,16'h0000},
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
                                                      '{//action 0; observation 1
                                                      '{16'h0001,16'h0000},
                                                      '{16'hffff,16'h0000},
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
                                                       }
                                                      },
                                                    '{//action 1
                                                      '{//action 1; observation 0
                                                      '{16'h0001,16'h0000},
                                                      '{16'h0001,16'h0000},
                                                      '{16'hffff,16'h0000},
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
                                                      '{//action 1; observation 1
                                                      '{16'h0001,16'h0000},
                                                      '{16'h0001,16'h0000},
                                                      '{16'h0001,16'h0000},
                                                      '{16'hffff,16'h0000},
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
                                                       }
                                                      },
                                                    '{//action 2
                                                      '{//action 2; observation 0
                                                      '{16'h0001,16'h0000},
                                                      '{16'h0001,16'h0000},
                                                      '{16'h0001,16'h0000},
                                                      '{16'h0001,16'h0000},
                                                      '{16'hffff,16'h0000},
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
                                                      '{//action 2; observation 1
                                                      '{16'h0001,16'h0000},
                                                      '{16'h0001,16'h0000},
                                                      '{16'h0001,16'h0000},
                                                      '{16'h0001,16'h0000},
                                                      '{16'h0001,16'h0000},
                                                      '{16'hffff,16'h0000},
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
                                                       }
                                                      }
                                                    };
    gamma_reward_action = '{{7209,0},{0,7209},{6488,6488}};

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
    $display("point_action %d : %p\n" ,counter_finish, gamma_action_belief);
    $display("en_loop %d : %d\n" ,counter_finish, en_step3);
  end

endmodule