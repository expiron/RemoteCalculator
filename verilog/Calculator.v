module Calculator(
	input            clk,
	input            reset,
	input            rxd,
	input      [3:0] num,
	input            numPressed,
	input      [1:0] opt,
	input            optPressed,
	input            clear,
	input            submit,
	output     [3:0] n,
	output     [3:0] num1,
	output     [3:0] num2,
	output reg [3:0] num3,
	output reg [3:0] num4,
	output reg       sign,
	output reg       clcZero,
	output           txd
);

	reg [3:0] state;
	reg [3:0] a;
	reg [1:0] operation;
	reg [3:0] b;
	reg [7:0] ans;

	reg       txdStart;
	reg [7:0] txdData;
	wire[7:0] rxdData;
	wire      rxdDataReady;
	wire      rxdDataCheck;

	assign n = 4'b0100;
	assign num1 = a;
	assign num2 = b;
	assign rxdDataCheck = ((rxdData[7:4] == 4'b0011) & (rxdData[3:0] < 10));

	ReceiveData receiveData(
		.clk(clk),
		.reset(reset),
		.rxd(rxd),
		.data(rxdData),
		.rxdDataReady(rxdDataReady)
	);

	TransmitData transmitData(
		.clk(clk),
		.reset(reset),
		.txdStart(txdStart),
		.data(txdData),
		.txd(txd),
		.txdBusy(txdBusy)
	);

	always @ (posedge clk or negedge reset) begin
		if (!reset) begin
			state <= 0;
		end
		else
			case (state)
				0: if (rxdDataReady & rxdDataCheck) state <= 1;// else state <= 0;
				1: if (optPressed)   state <= 2;// else state <= 1;
				2: if (numPressed)   state <= 3; else if (clear) state <= 1;// else state <= 2;
				3: if (submit)       state <= 4; else if (clear) state <= 1;// else state <= 3;
				4: state <= 5;
				5: if (~txdBusy)     state <= 6;// else state <= 5;
				6: if (~txdBusy)     state <= 7;// else state <= 6;
				7: if (~submit)      state <= 0;// else state <= 7;
			endcase
	end

	always @ (posedge clk or negedge reset) begin
		if (!reset) begin
			a <= 0;
			operation <= 0;
			b <= 0;
			ans <= 0;
			num3 <= 0;
			num4 <= 0;
			sign <= 0;
			clcZero <= 0;
		end
		else if (clear) begin
			operation <= 0;
			b <= 0;
		end
		else case (state)
			0: if (rxdDataReady & rxdDataCheck) a <= rxdData[3:0];// else a <= 0;
			1: begin
				if (rxdDataReady & rxdDataCheck) a <= rxdData[3:0];
				if (optPressed) operation <= opt; else operation <= 0;
				sign <= 0;
				clcZero <= 0;
			end
			2: begin
				if (optPressed) operation <= opt;
				if (numPressed) b <= num; else b <= 0;
			end
			3: begin
				if (numPressed) b <= num;
				ans <= {4'b0000,a} + {4'b0000,b};
			end
			4: begin
				if (operation == 1) begin
					num3 <= ans / 10;
					num4 <= ans % 10;
					sign <= 0;
					clcZero <= 0;
				end
				else if (operation == 2) begin
					if (a >= b) begin
						num3 <= 0;
						num4 <= a - b;
						sign <= 0;
						clcZero <= ((a - b) == 0 ? 1 : 0);
					end
					else begin
						num3 <= 14;
						num4 <= 14;
						sign <= 1;
						clcZero <= 0;
					end
				end
				else begin
					num3 <= 14;
					num4 <= 14;
					sign <= 0;
					clcZero <= 0;
				end
			end
			default: ;
		endcase
	end

	always @ (state or reset) begin
		if (!reset) begin
			txdData <= 8'b00000000;
			txdStart <= 0;
		end
		else case (state)
			0, 1, 2, 3, 4:   begin txdStart <= 0; txdData <= 8'b00000000; end
			5: if (~txdBusy) begin txdStart <= (num3 == 0 ? 0 : 1); txdData <= (num3 >= 10 ? 8'b01000101 : {4'b0011,num3}); end
			6: if (~txdBusy) begin txdStart <= 1; txdData <= (num4 >= 10 ? 8'b01000101 : {4'b0011,num4}); end
			7: if (~txdBusy) begin txdStart <= 0; txdData <= 8'b00000000; end
			default:         begin txdStart <= 0; txdData <= 8'b00000000; end
		endcase
	end

endmodule