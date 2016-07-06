module Receive(
	input            clk,
	input            reset,
	input            rxd,
	input            clear,
	input            submit,
	output reg [3:0] num1,
	output reg [3:0] num2,
	output reg [3:0] num3,
	output reg [3:0] num4
);
/* Max Length of input buffer */
	parameter maxLength = 8;
	reg [3:0] mem1;
	reg [3:0] mem2;
	reg [3:0] mem3;
	reg [3:0] mem4;
	reg [3:0] mem5;
	reg [3:0] mem6;
	reg [3:0] mem7;
	reg [3:0] mem8;
	reg [3:0] tmp1;
	reg [3:0] tmp2;
	reg [3:0] tmp3;
	reg [3:0] tmp4;
	reg [3:0] tmp5;
	reg [3:0] tmp6;
	reg [3:0] tmp7;
	reg [3:0] tmp8;
	reg [3:0] cnt;
	reg       readyDelay;
	reg       complete;
	reg [3:0] state;
	wire [7:0] data;
	wire rxdDataReady;
	wire showClk;

	ReceiveData receiveData(
		.clk(clk),
		.reset(reset),
		.rxd(rxd),
		.data(data),
		.rxdDataReady(rxdDataReady)
	);

	always @ (posedge clk or negedge reset) begin
		if (!reset) begin
			mem1 <= 0;
			mem2 <= 0;
			mem3 <= 0;
			mem4 <= 0;
			mem5 <= 0;
			mem6 <= 0;
			mem7 <= 0;
			mem8 <= 0;
			cnt <= 0;
			readyDelay <= 0;
		end
		else if (complete)
			cnt <= 0;
		else if (rxdDataReady & ~readyDelay) begin
			mem1 <= (mem2 & ((cnt < 7) ? 4'b0000 : 4'b1111));
			mem2 <= (mem3 & ((cnt < 6) ? 4'b0000 : 4'b1111));
			mem3 <= (mem4 & ((cnt < 5) ? 4'b0000 : 4'b1111));
			mem4 <= (mem5 & ((cnt < 4) ? 4'b0000 : 4'b1111));
			mem5 <= (mem6 & ((cnt < 3) ? 4'b0000 : 4'b1111));
			mem6 <= (mem7 & ((cnt < 2) ? 4'b0000 : 4'b1111));
			mem7 <= (mem8 & ((cnt < 1) ? 4'b0000 : 4'b1111));
			mem8 <= data[3:0];
			cnt <= ((cnt + 1 > 8) ? 8 : (cnt + 1));
			readyDelay <= 1;
		end
		else if (clear & ~readyDelay) begin
			mem1 <= 0;
			mem2 <= 0;
			mem3 <= 0;
			mem4 <= 0;
			mem5 <= 0;
			mem6 <= 0;
			mem7 <= 0;
			mem8 <= 0;
			cnt <= 0;
			readyDelay <= 1;
		end
		else if (~rxdDataReady & ~clear)
			readyDelay <= 0;
	end

//	always @ (posedge clk or negedge reset) begin
//		if (!reset) begin
//			num1 <= 0;
//			num2 <= 0;
//			num3 <= 0;
//			num4 <= 0;
//		end
//		else if (submit) begin
//			complete <= 1;
//			num1 <= mem5;
//			num2 <= mem6;
//			num3 <= mem7;
//			num4 <= mem8;
//		end
//		else
//			complete <= 0;
//	end

	always @ (posedge clk or negedge reset) begin
		if (!reset) begin
			tmp1 <= 0;
			tmp2 <= 0;
			tmp3 <= 0;
			tmp4 <= 0;
			tmp5 <= 0;
			tmp6 <= 0;
			tmp7 <= 0;
			tmp8 <= 0;
		end
		else if (submit) begin
			complete <= 1;
			tmp1 <= mem1;
			tmp2 <= mem2;
			tmp3 <= mem3;
			tmp4 <= mem4;
			tmp5 <= mem5;
			tmp6 <= mem6;
			tmp7 <= mem7;
			tmp8 <= mem8;
		end
		else
			complete <= 0;
	end

	FrequencyDivider # (.divFreq(2)) divider(
		.clk(clk),
		.reset(reset),
		.divClk(showClk)
	);

	always @ (posedge showClk or negedge reset) begin
		if (!reset)
			state <= 0;
		else
			case (state)
				0: state <= 1;
				1: state <= 2;
				2: state <= 3;
				3: state <= 4;
				4: state <= 0;
				default: state <= 0;
			endcase
	end

	always @ (state or reset) begin
		if (!reset) begin
			num1 <= 0;
			num2 <= 0;
			num3 <= 0;
			num4 <= 0;
		end
		else
			case (state)
				0: begin num1 <= tmp1; num2 <= tmp2; num3 <= tmp3; num4 <= tmp4; end
				1: begin num1 <= tmp2; num2 <= tmp3; num3 <= tmp4; num4 <= tmp5; end
				2: begin num1 <= tmp3; num2 <= tmp4; num3 <= tmp5; num4 <= tmp6; end
				3: begin num1 <= tmp4; num2 <= tmp5; num3 <= tmp6; num4 <= tmp7; end
				4: begin num1 <= tmp5; num2 <= tmp6; num3 <= tmp7; num4 <= tmp8; end
			endcase
	end
endmodule