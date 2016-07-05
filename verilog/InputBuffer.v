module InputBuffer(
	input            clk,
	input            reset,
	input      [3:0] num,
	input            numPressed,
	input            clear,
	input            submit,
	output    [3:0] num1,
	output    [3:0] num2,
	output    [3:0] num3,
	output    [3:0] num4
);

/* Max Length of input buffer */
	parameter maxLength = 8;
	reg [1:0] state;
//	reg [3:0] tmp [0:maxLength + 1];
	reg [3:0] mem[maxLength:0];
	reg [7:0] cnt;

	always @ (numPressed or clear or reset) begin
		if (!reset) begin
			mem[0] <= 0;
			mem[1] <= 0;
			mem[2] <= 0;
			mem[3] <= 0;
			mem[4] <= 0;
			cnt <= 0;
		end
		else if (numPressed) begin
			mem[0] <= mem[1];
			mem[1] <= mem[2];
			mem[2] <= mem[3];
			mem[3] <= mem[4];
			mem[4] <= num;
			cnt <= cnt + 1;
		end
		else if (clear) begin
			mem[0] <= 0;
			mem[1] <= mem[0];
			mem[2] <= mem[1];
			mem[3] <= mem[2];
			mem[4] <= mem[3];
			cnt <= cnt - 1;
		end
	end

	assign num1 = mem[1];
	assign num2 = mem[2];
	assign num3 = mem[3];
	assign num4 = mem[4];
//	always @ (*) begin
//		num1 <= mem[5];
//		num2 <= mem[6];
//		num3 <= mem[7];
//		num4 <= mem[8];
//	end
//	always @ (posedge clk or negedge reset) begin
//		if (!reset)
//			state <= 2'b00;
//		else
//			case (state)
//				2'b00: if (numPressed)  state <= 2'b01; else if (clear) state <= 2'b11;
//				2'b01: state <= 2'b10;
//				2'b10: if (!numPressed) state <= 2'b00;
//				2'b11: state <= 2'b00;
//				default: state <= 2'b00;
//			endcase
//	end
//
//	always @ (state or reset) begin
//		if (!reset)
//			cnt <= 1;
//		else
//			case (state)
//				2'b00: mem[cnt*4-1:(cnt-1)*4] <= 0;
//				2'b01: mem[cnt*4-1:(cnt-1)*4] <= num;
//				2'b10: if (cnt <= maxLength) cnt <= cnt + 1; else cnt <= maxLength;
//				2'b11: if (cnt > 1) cnt <= cnt - 1; else cnt <= 1;
//			endcase
//	end
//
//	always @ (posedge clk or negedge reset) begin
//		if (!reset) begin
//			num1 <= 0;
//			num2 <= 0;
//			num3 <= 0;
//			num4 <= 0;
//		end
//		else
//			case (cnt)
//				1: begin
//					num1 <= 0;
//					num2 <= 0;
//					num3 <= 0;
//					num4 <= 0;
//				end
//				2: begin
//					num1 <= 0;
//					num2 <= 0;
//					num3 <= 0;
//					num4 <= mem[(cnt-1)*4-1:(cnt-2)*4];
//				end
//				3: begin
//					num1 <= 0;
//					num2 <= 0;
//					num3 <= mem[(cnt-1)*4-1:(cnt-2)*4];
//					num4 <= mem[(cnt-2)*4-1:(cnt-3)*4];
//				end
//				4: begin
//					num1 <= 0;
//					num2 <= mem[(cnt-1)*4-1:(cnt-2)*4];
//					num3 <= mem[(cnt-2)*4-1:(cnt-3)*4];
//					num4 <= mem[(cnt-3)*4-1:(cnt-4)*4];
//				end
//				default: begin
//					num1 <= mem[(cnt-1)*4-1:(cnt-2)*4];
//					num2 <= mem[(cnt-2)*4-1:(cnt-3)*4];
//					num3 <= mem[(cnt-3)*4-1:(cnt-4)*4];
//					num4 <= mem[(cnt-4)*4-1:(cnt-5)*4];
//				end
//			endcase
//	end
//	always @ (posedge numPressed or negedge reset) begin
//		if (!reset) begin
//			num1 <= 0;
//			num2 <= 0;
//			num3 <= 0;
//			num4 <= 0;
//		end
//		else if (num < 10) begin
//			num1 <= num2;
//			num2 <= num3;
//			num3 <= num4;
//			num4 <= num;
//		end
//		else begin
//			num1 <= num1;
//			num2 <= num2;
//			num3 <= num3;
//			num4 <= num4;
//		end
//	end
//	always @ (posedge showClk or negedge reset) begin
//		if (!reset) begin
//			num1 <= 0;
//			num2 <= 0;
//			num3 <= 0;
//			num4 <= 0;
//		end
//		else if (show) begin
//			if (showCnt <= nInput - 4)
//				showCnt <= showCnt + 1;
//			else
//				showCnt <= 1;
//			num1 <= mem[showCnt];
//			num2 <= mem[showCnt + 1];
//			num3 <= mem[showCnt + 2];
//			num4 <= mem[showCnt + 3];
//		end
//		else
//			showCnt <= 1;
//	end

endmodule