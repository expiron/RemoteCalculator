`timescale 1 ns/ 1 ps
module Transmit_tst();

	parameter period = 2;
	reg clear;
	reg clk;
	reg [3:0] num;
	reg numPressed;
	reg reset;
	reg submit;

	wire [3:0]  num1;
	wire [3:0]  num2;
	wire [3:0]  num3;
	wire [3:0]  num4;
	wire txd;

	Transmit inst1 (
		.clear(clear),
		.clk(clk),
		.num(num),
		.num1(num1),
		.num2(num2),
		.num3(num3),
		.num4(num4),
		.numPressed(numPressed),
		.reset(reset),
		.submit(submit),
		.txd(txd)
	);

	always # (period / 2) clk = ~clk;

	initial begin
		clk = 0;
		reset = 0;
		num = 0;
		numPressed = 0;
		clear = 0;
		submit = 0;
		# period reset = 1;
		# period num = 8;
		numPressed = 1;
		# (period * 2) num = 0;
		numPressed = 0;
		# period submit = 1;
		# period submit = 0;
		# 70000;
		# period num = 1;
		numPressed = 1;
		# (period * 2) num = 0;
		numPressed = 0;
		
		# period num = 2;
		numPressed = 1;
		# (period * 2) num = 0;
		numPressed = 0;
		
		# period num = 3;
		numPressed = 1;
		# (period * 2) num = 0;
		numPressed = 0;
		
		#(period * 9) submit = 1;
		#(period * 2) submit = 0;
	end
endmodule
