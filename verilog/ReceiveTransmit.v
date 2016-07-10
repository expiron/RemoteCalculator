module ReceiveTransmit(
	input            clk,
	input            reset,
	input            rxd,
	input            clear,
	input            submit,
	output reg [3:0] n,
	output reg [3:0] num1,
	output reg [3:0] num2,
	output reg [3:0] num3,
	output reg [3:0] num4,
	output           txd
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
	reg [3:0] tstate;
	reg [3:0] sstate;
	reg       txdStart;
	reg [7:0] txdData;
	wire [7:0] rxdData;
	wire rxdDataReady;
	wire showClk;
	wire      rxdDataCheck;

	assign rxdDataCheck = ((rxdData[7:4] == 4'b0011) & (rxdData[3:0] < 10));

	FrequencyDivider # (.divFreq(2)) divider(
		.clk(clk),
		.reset(reset),
		.divClk(showClk)
	);

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
		else if (rxdDataReady & rxdDataCheck & ~readyDelay) begin
			mem1 <= (mem2 & ((cnt < 7) ? 4'b0000 : 4'b1111));
			mem2 <= (mem3 & ((cnt < 6) ? 4'b0000 : 4'b1111));
			mem3 <= (mem4 & ((cnt < 5) ? 4'b0000 : 4'b1111));
			mem4 <= (mem5 & ((cnt < 4) ? 4'b0000 : 4'b1111));
			mem5 <= (mem6 & ((cnt < 3) ? 4'b0000 : 4'b1111));
			mem6 <= (mem7 & ((cnt < 2) ? 4'b0000 : 4'b1111));
			mem7 <= (mem8 & ((cnt < 1) ? 4'b0000 : 4'b1111));
			mem8 <= rxdData[3:0];
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

	always @ (posedge clk or negedge reset) begin
		if (!reset) begin
			state <= 0;
		end
		else
			case (state)
				0: if (submit & ~complete) begin state <= 9 - cnt; tstate <= 9 - cnt; end else if (submit & complete) state <= tstate;
				1: if (~txdBusy) state <= 2;
				2: if (~txdBusy) state <= 3;
				3: if (~txdBusy) state <= 4;
				4: if (~txdBusy) state <= 5;
				5: if (~txdBusy) state <= 6;
				6: if (~txdBusy) state <= 7;
				7: if (~txdBusy) state <= 8;
				8: if (~txdBusy) state <= 9;
				9: if (~submit)  state <= 0;
				default: if(~submit & ~txdBusy) state <= 0;
			endcase
	end

	always @ (state or reset) begin
		if (!reset) begin
			txdStart <= 0;
			txdData <= 8'b00000000;
		end
		else
			case (state)
				0: begin txdStart <= 0; txdData <= 8'b00000000; end
				1: if(~txdBusy) begin txdStart <= 1; txdData <= {4'b0011,mem1}; end
				2: if(~txdBusy) begin txdStart <= 1; txdData <= {4'b0011,mem2}; end
				3: if(~txdBusy) begin txdStart <= 1; txdData <= {4'b0011,mem3}; end
				4: if(~txdBusy) begin txdStart <= 1; txdData <= {4'b0011,mem4}; end
				5: if(~txdBusy) begin txdStart <= 1; txdData <= {4'b0011,mem5}; end
				6: if(~txdBusy) begin txdStart <= 1; txdData <= {4'b0011,mem6}; end
				7: if(~txdBusy) begin txdStart <= 1; txdData <= {4'b0011,mem7}; end
				8: if(~txdBusy) begin txdStart <= 1; txdData <= {4'b0011,mem8}; end
				9: if(~txdBusy) begin txdStart <= 0; txdData <= 8'b00000000; end
				default: begin txdStart <= 0; txdData <= 8'b00000000; end
			endcase
	end

//	always @ (posedge clk or negedge reset) begin
//		if (!reset)
//			complete <= 0;
//		else
//			if (state == 9)
//				complete <= 1;
//			else if (rxdDataReady)
//				complete <= 0;
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
			complete <= 0;
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

	always @ (posedge clk or negedge reset) begin
		if (!reset)
			n <= 0;
		else if (submit && ~complete)
			n <= cnt;
	end

	always @ (posedge showClk or negedge reset) begin
		if (!reset)
			sstate <= 0;
		else
			case (sstate)
				0: sstate <= 1;
				1: sstate <= 2;
				2: sstate <= 3;
				3: sstate <= 4;
				4: if (n == 8) sstate <= 0; else if (n == 7) sstate <= 1; else if (n == 6) sstate <= 2; else if (n == 5) sstate <= 3; else sstate <= 4;
				default: sstate <= 0;
			endcase
	end

	always @ (sstate or reset) begin
		if (!reset) begin
			num1 <= 0;
			num2 <= 0;
			num3 <= 0;
			num4 <= 0;
		end
		else
			case (sstate)
				0: begin num1 <= tmp1; num2 <= tmp2; num3 <= tmp3; num4 <= tmp4; end
				1: begin num1 <= tmp2; num2 <= tmp3; num3 <= tmp4; num4 <= tmp5; end
				2: begin num1 <= tmp3; num2 <= tmp4; num3 <= tmp5; num4 <= tmp6; end
				3: begin num1 <= tmp4; num2 <= tmp5; num3 <= tmp6; num4 <= tmp7; end
				4: begin num1 <= tmp5; num2 <= tmp6; num3 <= tmp7; num4 <= tmp8; end
			endcase
	end

endmodule
