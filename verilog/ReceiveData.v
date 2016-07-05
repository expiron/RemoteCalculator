module ReceiveData(
	input            clk,
	input            reset,
	input            rxd,
	output reg [7:0] data,
	output reg       rxdDataReady
);

/* Frequency of the Keyboard */
	parameter ClkFrequency = 25000000;  // 时钟频率－25 MHz
	parameter Baud = 9600;              // 串口波特率－9600
	parameter Baud8 = Baud * 8;
	parameter Baud8GeneratorAccWidth = 16;
/* Registers */
	reg [2:0] bitSpacing;
	reg       rxdDelay;
	reg       rxdStart;
	reg [3:0] state;
/* Wires */
	wire      nextBit;

/* Generate Baud8Tick */
	reg  [Baud8GeneratorAccWidth:0] Baud8GeneratorAcc;
	wire [Baud8GeneratorAccWidth:0] Baud8GeneratorInc = ((Baud8<<(Baud8GeneratorAccWidth-7))+(ClkFrequency>>8))/(ClkFrequency>>7);
	wire Baud8Tick = Baud8GeneratorAcc[Baud8GeneratorAccWidth];
	always @ (posedge clk or negedge reset) begin
		if (!reset)
			Baud8GeneratorAcc <= 0;
		else
			Baud8GeneratorAcc <= Baud8GeneratorAcc[Baud8GeneratorAccWidth-1:0] + Baud8GeneratorInc;
	end

	always @ (posedge clk or negedge reset) begin
		if (~reset)
			bitSpacing <= 0;
		else if (state == 0)
			bitSpacing <= 0;
		else if (Baud8Tick)
			bitSpacing <= bitSpacing + 1;
	end

	assign nextBit = (bitSpacing == 7);

	always @ (posedge clk) begin
		if (Baud8Tick) begin
			rxdDelay <= rxd;
			rxdStart <= (Baud8Tick & rxdDelay & (~rxd));
		end
	end

	always @ (posedge clk or negedge reset) begin
		if (!reset)
			state <= 4'b0000;
		else if (Baud8Tick)
			case (state)
				4'b0000: if (rxdStart) state <= 4'b1000;
				4'b1000: if (nextBit)  state <= 4'b1001;
				4'b1001: if (nextBit)  state <= 4'b1010;
				4'b1010: if (nextBit)  state <= 4'b1011;
				4'b1011: if (nextBit)  state <= 4'b1100;
				4'b1100: if (nextBit)  state <= 4'b1101;
				4'b1101: if (nextBit)  state <= 4'b1110;
				4'b1110: if (nextBit)  state <= 4'b1111;
				4'b1111: if (nextBit)  state <= 4'b0001;
				4'b0001: if (nextBit)  state <= 4'b0000;
				default: state <= 4'b0000;
			endcase
	end

	always @ (posedge clk or negedge reset) begin
		if (!reset)
			data <= 8'b00000000;
		else if (Baud8Tick & nextBit & state[3])
			data <= {rxd, data[7:1]};
	end

	always @ (posedge clk or negedge reset) begin
		if (!reset)
			rxdDataReady <= 0;
		else
			rxdDataReady <= (Baud8Tick && nextBit && state == 4'b0001);
	end

endmodule
