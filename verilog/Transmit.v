module Transmit(
	input            clk,
	input            reset,
	input      [3:0] num,
	input            numPressed,
	input            clear,
	input            submit,
	output     [3:0] num1,
	output     [3:0] num2,
	output     [3:0] num3,
	output     [3:0] num4,
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
	reg [3:0] cnt;
	reg [3:0] state;
	reg [3:0] tstate;
	reg pressDelay;
	reg  txdStart;
	reg [7:0] data;
	reg       complete;
	wire txdBusy;

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
			pressDelay <= 0;
		end
		else if (complete)
			cnt <= 0;
		else if (numPressed & ~pressDelay) begin
			mem1 <= (mem2 & ((cnt < 7) ? 4'b0000 : 4'b1111));
			mem2 <= (mem3 & ((cnt < 6) ? 4'b0000 : 4'b1111));
			mem3 <= (mem4 & ((cnt < 5) ? 4'b0000 : 4'b1111));
			mem4 <= (mem5 & ((cnt < 4) ? 4'b0000 : 4'b1111));
			mem5 <= (mem6 & ((cnt < 3) ? 4'b0000 : 4'b1111));
			mem6 <= (mem7 & ((cnt < 2) ? 4'b0000 : 4'b1111));
			mem7 <= (mem8 & ((cnt < 1) ? 4'b0000 : 4'b1111));
			mem8 <= num;
			cnt <= ((cnt + 1 > 8) ? 8 : (cnt + 1));
			pressDelay <= 1;
		end
		else if (clear & ~pressDelay) begin
			mem1 <= 0;
			mem2 <= mem1;
			mem3 <= mem2;
			mem4 <= mem3;
			mem5 <= mem4;
			mem6 <= mem5;
			mem7 <= mem6;
			mem8 <= mem7;
			cnt <= (cnt == 0 ? 0 : (cnt - 1));
			pressDelay <= 1;
		end
		else if (~numPressed & ~clear)
			pressDelay <= 0;
	end

	TransmitData transmitData(
		.clk(clk),
		.reset(reset),
		.txdStart(txdStart),
		.data(data),
		.txd(txd),
		.txdBusy(txdBusy)
	);

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
			data <= 8'b00000000;
		end
		else
			case (state)
				0: begin txdStart <= 0; data <= 8'b00000000; end
				1: if(~txdBusy) begin txdStart <= 1; data <= 8'b00110000 + {4'b0000,mem1}; end
				2: if(~txdBusy) begin txdStart <= 1; data <= 8'b00110000 + {4'b0000,mem2}; end
				3: if(~txdBusy) begin txdStart <= 1; data <= 8'b00110000 + {4'b0000,mem3}; end
				4: if(~txdBusy) begin txdStart <= 1; data <= 8'b00110000 + {4'b0000,mem4}; end
				5: if(~txdBusy) begin txdStart <= 1; data <= 8'b00110000 + {4'b0000,mem5}; end
				6: if(~txdBusy) begin txdStart <= 1; data <= 8'b00110000 + {4'b0000,mem6}; end
				7: if(~txdBusy) begin txdStart <= 1; data <= 8'b00110000 + {4'b0000,mem7}; end
				8: if(~txdBusy) begin txdStart <= 1; data <= 8'b00110000 + {4'b0000,mem8}; end
				9: if(~txdBusy) begin txdStart <= 0; data <= 8'b00000000; end
				default: begin txdStart <= 0; data <= 8'b00000000; end
			endcase
	end

	always @ (posedge clk or negedge reset) begin
		if (!reset)
			complete <= 0;
		else
			if (state == 9)
				complete <= 1;
			else if (numPressed)
				complete <= 0;
	end
	
	assign num1 = mem5;
	assign num2 = mem6;
	assign num3 = mem7;
	assign num4 = mem8;

endmodule