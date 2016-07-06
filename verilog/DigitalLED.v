module DigitalLED (
	input            clk,
	input            reset,
	input      [3:0] n,
	input      [3:0] num1,
	input      [3:0] num2,
	input      [3:0] num3,
	input      [3:0] num4,
	output reg [3:0] com,
	output reg [7:0] seg
);

/* Frequency of the Keyboard */
	parameter ledFreq = 250;
/* Constant of the SM */
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
/* Registers */
	integer   ledCnt;
	reg       ledClk;
	reg [1:0] state = S0;
	reg [3:0] num;

/* Scan State Machine */
	always @ (posedge ledClk) begin
		case (state)
			S0:	state = S1;
			S1:	state = S2;
			S2:	state = S3;
			S3:	if (n == 1) state <= S3; else if (n == 2) state <= S2; else if (n == 3) state <= S1; else state <= S0;
		endcase
	end

/* Data&Seg Selector */
	always @ (posedge ledClk or negedge reset) begin
		if (!reset) begin
			com <= 4'b0000;
		end
		else if (n == 0) begin
			com <= 4'b0000;
		end
		else begin
			case (state)
				S0: begin num <= num1; com <= 4'b1000; end
				S1: begin num <= num2; com <= 4'b0100; end
				S2: begin num <= num3; com <= 4'b0010; end
				S3: begin num <= num4; com <= 4'b0001; end
			endcase
		end
	end

/* Seven-Segment Decoder */
	always @ ( * ) begin
		case (num)
			4'h0: seg <= 8'b00000011;       // 0
			4'h1: seg <= 8'b10011111;       // 1
			4'h2: seg <= 8'b00100101;       // 2
			4'h3: seg <= 8'b00001101;       // 3
			4'h4: seg <= 8'b10011001;       // 4
			4'h5: seg <= 8'b01001001;       // 5
			4'h6: seg <= 8'b01000001;       // 6
			4'h7: seg <= 8'b00011111;       // 7
			4'h8: seg <= 8'b00000001;       // 8
			4'h9: seg <= 8'b00001001;       // 9
			4'ha: seg <= 8'b00010001;       // A
			4'hb: seg <= 8'b11000001;       // b
			4'hc: seg <= 8'b01100011;       // C
			4'hd: seg <= 8'b10000101;       // d
			4'he: seg <= 8'b01100001;       // E
			4'hf: seg <= 8'b01110001;       // F
		endcase
	end

/* Generate Clock */
	always @ (posedge clk or negedge reset) begin
		if (!reset) begin
			ledCnt <= 0;
			ledClk <= 0;
		end
		else  if (ledCnt < (25000000 / ledFreq - 1) / 2) begin
					ledCnt <= ledCnt + 1;
				end
				else begin
					ledCnt <= 0;
					ledClk <= ~ledClk;
				end
	end

endmodule
