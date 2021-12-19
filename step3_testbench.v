`timescale  1ns/1ns
module step3_tb ();
reg clk;
reg en;

initial 
begin
    clk=0;
    en=0;
    #500 en=1;
end

always#100 clk=~clk;

step3 dut
(
    .clk(clk),
    .en(en)
);
endmodule
