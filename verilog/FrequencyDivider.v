module FrequencyDivider(
	input      clk,
	input      reset,
	output reg divClk
);

	parameter divFreq = 12500000;
	integer   divCnt;

/* Generate Clock */
	always @ (posedge clk or negedge reset) begin
		if (!reset) begin
			divCnt <= 0;
			divClk <= 0;
		end
		else  if (divCnt < (25000000 / divFreq - 1) / 2) begin
					divCnt <= divCnt + 1;
				end
				else begin
					divCnt <= 0;
					divClk <= ~divClk;
				end
	end

endmodule