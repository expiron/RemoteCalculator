module KeyboardDecoder(
	input            clk,
	input            reset,
	input      [3:0] row,
	output     [3:0] col,
	output     [3:0] num,
	output reg       numPressed,
	output reg [1:0] opt,
	output reg       optPressed,
	output reg       clear,
	output reg       submit
);

/* Wires */
	wire     keyPressed;

/* Instance of Universal Keyboard */
	Keyboard # (.kbdFreq(50)) keyboard(
		.clk(clk),
		.reset(reset),
		.row(row),
		.col(col),
		.num(num),
		.keyPressed(keyPressed)
	);

/* Decode the code of the key */
	always @ (keyPressed) begin
		if (keyPressed)
			case (num)
				4'h0, 4'h1, 4'h2, 4'h3, 4'h4, 4'h5, 4'h6, 4'h7, 4'h8, 4'h9: begin
					numPressed <= 1; opt <= 0; optPressed <= 0; clear <= 0; submit <= 0;
				end
				4'ha: begin
					numPressed <= 0; opt <= 1; optPressed <= 1; clear <= 0; submit <= 0;
				end
				4'hb: begin
					numPressed <= 0; opt <= 2; optPressed <= 1; clear <= 0; submit <= 0;
				end
				4'he: begin
					numPressed <= 0; opt <= 0; optPressed <= 0; clear <= 1; submit <= 0;
				end
				4'hf: begin
					numPressed <= 0; opt <= 0; optPressed <= 0; clear <= 0; submit <= 1;
				end
				default: begin
					numPressed <= 0; opt <= 0; optPressed <= 0; clear <= 0; submit <= 0;
				end
			endcase
		else begin
			numPressed <= 0;
			opt        <= 0;
			optPressed <= 0;
			clear      <= 0;
			submit     <= 0;
		end
	end

endmodule
