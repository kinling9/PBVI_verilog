module solve_pbvi (
  input logic clk,
  input logic rst_n,
  input logic en,
  input logic [15:0] max_iter,
  input logic [15:0] discount,
  input logic [15:0] alpha_in [0:15][0:1],
  input logic [15:0] vec_reward [0:2][0:1],
  input logic [15:0] trans [0:2][0:1][0:1],
  input logic [15:0] observe [0:2][0:1][0:1],
  output logic en_solved,
  output logic [1:0] point_action [0:15],
  output logic [15:0] alpha_out [0:15][0:1]
);

parameter STATE_INIT = 3'b000;
parameter STATE_LOOP_INIT = 3'b001;
parameter STATE_LOOP_WAIT = 3'b010;
parameter STATE_LOOP_STOP = 3'b011;
parameter STATE_STOP = 3'b100;

logic [2:0] state;
logic en_step123;
logic en_loop;
logic [15:0] count;
logic [15:0] alpha_cur_in [0:15][0:1];
//logic [15:0] alpha_cur_out [0:15][0:1];


always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    state <= STATE_STOP;
  end else if (en) begin
    state <= STATE_INIT;
  end else if (state == STATE_STOP) begin
    state <= STATE_STOP;
  end else if (state == STATE_INIT) begin
    state <= STATE_LOOP_INIT; 
  end else if (state == STATE_LOOP_INIT) begin 
    state <= STATE_LOOP_WAIT;
  end else if (state == STATE_LOOP_WAIT) begin 
    if (en_loop) begin 
      if (count == max_iter) begin 
        state <= STATE_LOOP_STOP;
      end else begin 
        state <= STATE_LOOP_INIT;
      end
    end else begin 
      state <= STATE_LOOP_WAIT;
    end
  end else if (state == STATE_LOOP_STOP) begin 
    state <= STATE_STOP;
  end
end

always_ff @(posedge clk) begin
  case (state)
    STATE_INIT: begin
      count <= 0;
      alpha_cur_in <= alpha_in;
    end
    STATE_LOOP_INIT: begin
      en_step123 <= 1'b1;
      count <= count + 1;
    end
    STATE_LOOP_WAIT: begin
      en_step123 <= 1'b0;
      alpha_cur_in <= en_loop ? alpha_out : alpha_cur_in;
    end
    STATE_LOOP_STOP: begin
      //alpha_out <= alpha_cur_out;
    end
    STATE_STOP: begin
      count <= 0;
    end
    default: begin
    end
  endcase
end

always_comb begin
  if (state == STATE_LOOP_STOP) begin
    en_solved = 1'b1;
  end else if (state == STATE_STOP) begin
    en_solved = 1'b0;;
  end
end

step123 mod_step123 (
  .clk(clk),
  .rst_n(rst_n),
  .en(en_step123),
  .discount(discount),
  .alpha_in(alpha_cur_in),
  .vec_reward(vec_reward),
  .trans(trans),
  .observe(observe),
  .en_loop(en_loop),
  .point_action(point_action),
  .alpha_out(alpha_out)
);

endmodule
