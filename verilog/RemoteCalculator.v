module RemoteCalculator(
	input            clk,
	input            reset,
	input      [3:0] row,
	input            rxd,
	output     [3:0] col,
	output     [3:0] com,
	output     [7:0] seg,
	output           txd,
	output           sign,
	output           clcZero
);

//	reg [3:0] num1;
//	reg [3:0] num2;
//	reg [3:0] num3;
//	reg [3:0] num4;
	wire [7:0]data;
	wire rxdDataReady;
	wire[3:0] n;
	wire[3:0] num;
	wire[3:0] num1;
	wire[3:0] num2;
	wire[3:0] num3;
	wire[3:0] num4;
	wire[2:0] opt;
	wire      numPressed;
	wire      optPressed;
	wire      submit;

	KeyboardDecoder keyboard(
		.clk(clk),
		.reset(reset),
		.row(row),
		.col(col),
		.num(num),
		.numPressed(numPressed),
		.opt(opt),
		.optPressed(optPressed),
		.clear(clear),
		.submit(submit)
	);

	Calculator calc(
		.clk(clk),
		.reset(reset),
		.rxd(rxd),
		.num(num),
		.numPressed(numPressed),
		.opt(opt),
		.optPressed(optPressed),
		.clear(clear),
		.submit(submit),
		.n(n),
		.num1(num1),
		.num2(num2),
		.num3(num3),
		.num4(num4),
		.sign(sign),
		.clcZero(clcZero),
		.txd(txd)
	);

//	ReceiveTransmit recivTrans(
//		.clk(clk),
//		.reset(reset),
//		.rxd(rxd),
//		.clear(clear),
//		.submit(submit),
//		.n(n),
//		.num1(num1),
//		.num2(num2),
//		.num3(num3),
//		.num4(num4),
//		.txd(txd)
//	);

//	Receive reciv(
//		.clk(clk),
//		.reset(reset),
//		.rxd(rxd),
//		.clear(clear),
//		.submit(submit),
//		.num1(num1),
//		.num2(num2),
//		.num3(num3),
//		.num4(num4)
//	);

//	Transmit trans(
//		.clk(clk),
//		.reset(reset),
//		.num(num),
//		.numPressed(numPressed),
//		.clear(clear),
//		.submit(submit),
//		.num1(num1),
//		.num2(num2),
//		.num3(num3),
//		.num4(num4),
//		.txd(txd)
//	);

	DigitalLED # (.ledFreq(250)) digitalLED(
		.clk(clk),
		.reset(reset),
		.n(n),
		.num1(num1),
		.num2(num2),
		.num3(num3),
		.num4(num4),
		.com(com),
		.seg(seg)
	);

//	DigitalLED # (.ledFreq(250)) digitalLED(
//		.clk(clk),
//		.reset(reset),
//		.n(n),
//		.num1(1),
//		.num2(2),
//		.num3(3),
//		.num4(4),
//		.com(com),
//		.seg(seg)
//	);

//	always @ (posedge clk or negedge reset) begin
//		if (!reset) begin
//			num1 <= 0;
//			num2 <= 0;
//			num3 <= 0;
//			num4 <= 0;
//		end
//		else if (rxdDataReady) begin
//			num1 <= 0;
//			num2 <= data / 100;
//			num3 <= (data - 100 * num2) / 10;
//			num4 <= data % 10;
//		end
//	end

endmodule