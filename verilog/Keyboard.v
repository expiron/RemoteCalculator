module Keyboard (
	input            clk,
	input            reset,
	input      [3:0] row,
	output reg [3:0] col,
	output reg [3:0] num,
	output reg       keyPressed
);

/* Frequency of the Keyboard */
	parameter kbdFreq = 50;
/* Constant of the SM */
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
/* Registers */
	integer   scnCnt;
	reg       scnClk;
	integer   kbdCnt;
	reg       kbdClk;
	reg [3:0] samp [1:4];
	reg [1:0] state;
/* Wires */
	wire[3:0] inRow;

/* Stable input */
	assign inRow = samp[4] & samp[3] & samp[2] & samp[1];
	always @ (posedge scnClk) begin
		samp[4] <= samp[3];
		samp[3] <= samp[2];
		samp[2] <= samp[1];
		samp[1] <= row;
	end

/* Keyboard State Machine */
	always @ (posedge kbdClk) begin
		case (state)
			S0:	state <= (inRow ? S0 : S1);
			S1:	state <= (inRow ? S1 : S2);
			S2:	state <= (inRow ? S2 : S3);
			S3:	state <= (inRow ? S3 : S0);
		endcase
	end

/* Scan the keyboard row */
	always @ (state) begin
		case(state)
			S0:	col <= 4'b1000;
			S1:	col <= 4'b0100;
			S2:	col <= 4'b0010;
			S3:	col <= 4'b0001;
		endcase
	end

/* Translate the input */
	always @ (posedge kbdClk) begin
		case ( {inRow, col} )
			8'b1000_1000: begin num <= 4'h1; keyPressed <= 1; end
			8'b1000_0100: begin num <= 4'h2; keyPressed <= 1; end
			8'b1000_0010: begin num <= 4'h3; keyPressed <= 1; end
			8'b1000_0001: begin num <= 4'h4; keyPressed <= 1; end
			8'b0100_1000: begin num <= 4'h5; keyPressed <= 1; end
			8'b0100_0100: begin num <= 4'h6; keyPressed <= 1; end
			8'b0100_0010: begin num <= 4'h7; keyPressed <= 1; end
			8'b0100_0001: begin num <= 4'h8; keyPressed <= 1; end
			8'b0010_1000: begin num <= 4'h9; keyPressed <= 1; end
			8'b0010_0100: begin num <= 4'h0; keyPressed <= 1; end
			8'b0010_0010: begin num <= 4'ha; keyPressed <= 1; end
			8'b0010_0001: begin num <= 4'hb; keyPressed <= 1; end
			8'b0001_1000: begin num <= 4'hc; keyPressed <= 1; end
			8'b0001_0100: begin num <= 4'hd; keyPressed <= 1; end
			8'b0001_0010: begin num <= 4'he; keyPressed <= 1; end
			8'b0001_0001: begin num <= 4'hf; keyPressed <= 1; end
			default:      begin num <= 4'h0; keyPressed <= 0; end
		endcase
	end

/* Generate Clock */
	always @ (posedge clk or negedge reset) begin
		if (!reset) begin
			scnCnt <= 0;
			scnClk <= 0;
		end
		else  if (scnCnt < (25000000 / (kbdFreq * 10) - 1) / 2) begin
					scnCnt <= scnCnt + 1;
				end
				else begin
					scnCnt <= 0;
					scnClk <= ~scnClk;
				end
	end
	always @ (posedge clk or negedge reset) begin
		if (!reset) begin
			kbdCnt <= 0;
			kbdClk <= 0;
		end
		else  if (kbdCnt < (25000000 / kbdFreq - 1) / 2) begin
					kbdCnt <= kbdCnt + 1;
				end
				else begin
					kbdCnt <= 0;
					kbdClk <= ~kbdClk;
				end
	end

endmodule