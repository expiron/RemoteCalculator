module TransmitData(
	input            clk,
	input            reset,
	input            txdStart,
	input      [7:0] data,
	output reg       txd,
	output           txdBusy
);

/* Frequency of the Keyboard */
	parameter  ClkFrequency = 25000000;  // 时钟频率－25 MHz
	parameter  Baud = 9600;              // 串口波特率－9600
	parameter  BaudGeneratorAccWidth = 16;
/* Registers */
	reg [7:0] dataReg;
	reg [3:0] state;
/* Wires */
	wire      txdReady;

/* Generate BaudTick */
	reg  [BaudGeneratorAccWidth:0] BaudGeneratorAcc;
	wire [BaudGeneratorAccWidth:0] BaudGeneratorInc = ((Baud<<(BaudGeneratorAccWidth-4))+(ClkFrequency>>5))/(ClkFrequency>>4);
	wire BaudTick = BaudGeneratorAcc[BaudGeneratorAccWidth];
	always @ (posedge clk or negedge reset) begin
		if (!reset)
			BaudGeneratorAcc <= 0;
		else if (txdBusy)
			BaudGeneratorAcc <= BaudGeneratorAcc[BaudGeneratorAccWidth-1:0] + BaudGeneratorInc;
	end

	assign txdReady = (state == 0);
	assign txdBusy  = ~txdReady;

	always @ (posedge clk or negedge reset) begin
		if (!reset)
			dataReg <= 8'b00000000;
		else if (txdReady & txdStart)
			dataReg <= data;
	end

	always @ (posedge clk or negedge reset) begin
		if (!reset) begin
			state <= 4'b0000;
			txd   <= 1'b1;
		end
		else
			case (state)
				4'b0000: if (txdStart) begin state <= 4'b0100; txd <= 1'b1;       end
				4'b0100: if (BaudTick) begin state <= 4'b1000; txd <= 1'b0;       end
				4'b1000: if (BaudTick) begin state <= 4'b1001; txd <= dataReg[0]; end
				4'b1001: if (BaudTick) begin state <= 4'b1010; txd <= dataReg[1]; end
				4'b1010: if (BaudTick) begin state <= 4'b1011; txd <= dataReg[2]; end
				4'b1011: if (BaudTick) begin state <= 4'b1100; txd <= dataReg[3]; end
				4'b1100: if (BaudTick) begin state <= 4'b1101; txd <= dataReg[4]; end
				4'b1101: if (BaudTick) begin state <= 4'b1110; txd <= dataReg[5]; end
				4'b1110: if (BaudTick) begin state <= 4'b1111; txd <= dataReg[6]; end
				4'b1111: if (BaudTick) begin state <= 4'b0010; txd <= dataReg[7]; end
				4'b0010: if (BaudTick) begin state <= 4'b0011; txd <= 1'b1;       end
				4'b0011: if (BaudTick) begin state <= 4'b0000; txd <= 1'b1;       end
				default: if (BaudTick) begin state <= 4'b0000; txd <= 1'b1;       end
			endcase
	end

endmodule
