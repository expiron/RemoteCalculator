`timescale 1 ns/ 1 ps
module InputBuffer_tst();
reg clear;
reg clk;
reg [3:0] num;
reg numPressed;
reg reset;
reg submit;
// wires                                               
wire [3:0]  num1;
wire [3:0]  num2;
wire [3:0]  num3;
wire [3:0]  num4;

InputBuffer inst1 (
// port map - connection between master ports and signals/registers   
	.clear(clear),
	.clk(clk),
	.num(num),
	.num1(num1),
	.num2(num2),
	.num3(num3),
	.num4(num4),
	.numPressed(numPressed),
	.reset(reset),
	.submit(submit)
);

initial begin
	reset = 0;
	#80;
	reset = 1;
	#120;
	num = 1;
	numPressed = 1;
	#80;
	num = 0;
	numPressed = 0;
	#120;
	num = 3;
	numPressed = 1;
	#80;
	num = 0;
	numPressed = 0;
	#120;
	num = 8;
	numPressed = 1;
	#80;
	num = 0;
	numPressed = 0;
end
always # 20 clk = ~clk;
endmodule