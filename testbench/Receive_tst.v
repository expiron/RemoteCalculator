`timescale 1 ns/ 1 ps
module Receive_tst();
parameter period = 2;
reg clear;
reg clk;
reg reset;
reg submit;

wire [3:0]  num1;
wire [3:0]  num2;
wire [3:0]  num3;
wire [3:0]  num4;
reg rxd;

//TransmitData trans(
//	.clk(clk),
//	.reset(reset),
//	.txdStart(txdStart),
//	.data(data),
//	.txd(rxd),
//	.txdBusy(txdBusy)
//);

Receive inst1 (
	.clear(clear),
	.clk(clk),
	.num1(num1),
	.num2(num2),
	.num3(num3),
	.num4(num4),
	.reset(reset),
	.rxd(rxd),
	.submit(submit)
);

initial begin
	clk = 0;
	reset = 0;
	clear = 0;
	submit = 0;
	rxd = 1;
	# (period * 2) reset = 1;
//	# (period * 10) data = 49;
//	# (period * 10) txdStart = 1;
//	# (period * 1000);
//	wait (txdBusy == 0) begin
//		txdStart = 0;
//		submit = 1;
//		# (period * 10) submit = 0;
//	end
	# (30000)  rxd = 0;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 1;
	# (period * 3000) submit = 1;
	# (period * 10) submit = 0;
	
	# (5000)  rxd = 0;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 1;
	
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 1;
	
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 1;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 0;
	# (period * 2604) rxd = 1;
//	# (period * 10148)  rxd = 0;
//	# (period * 10148) rxd = 1;
//	# (period * 10148) rxd = 0;
//	# (period * 10148) rxd = 0;
//	# (period * 10148) rxd = 0;
//	# (period * 10148) rxd = 1;
//	# (period * 10148) rxd = 1;
//	# (period * 10148) rxd = 0;
//	# (period * 10148) rxd = 0;
//	# (period * 10148) rxd = 1;
//	# (period * 11000) submit = 1;
//	# (period * 5) submit = 0;
end
always # (period / 2) clk = ~clk;
endmodule