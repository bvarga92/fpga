/********************************************************************/
/*                                                                  */
/* Testbench a butterfly modulhoz (2 pontos FFT).                   */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module tb_butterfly;
	/* bemenetek */
	reg clk;
	reg signed [12:0] w_re, w_im, x1_re, x1_im, x2_re, x2_im;

	/* kimenetek */
	wire signed [12:0] y1_re, y1_im, y2_re, y2_im;

	butterfly uut(
		.clk(clk),
		.w_re(w_re),
		.w_im(w_im),
		.x1_re(x1_re),
		.x1_im(x1_im),
		.x2_re(x2_re),
		.x2_im(x2_im),
		.y1_re(y1_re),
		.y1_im(y1_im),
		.y2_re(y2_re),
		.y2_im(y2_im)
	);

	initial begin
		clk=0;
		w_re=13'b0111111111111;
		w_im=13'b0000000000000;
		/* x1=0.25 & x2=0.25  -->  y1=0.25 (b0010000000000) & y2=0 (b0000000000000) */
		x1_re=13'b0010000000000;
		x1_im=13'b0000000000000;
		x2_re=13'b0010000000000;
		x2_im=13'b0000000000000;
		#100
		/* x1=0.5 & x2=-0.25  -->  y1=0.125 (b0001000000000) & y2=0.375 (b0011000000000) */
		x1_re=13'b0100000000000;
		x1_im=13'b0000000000000;
		x2_re=13'b1110000000000;
		x2_im=13'b0000000000000;
		#100
		/* x1=1 & x2=1  -->  y1=1 (b0111111111111) & y2=0 (b0000000000000) */
		x1_re=13'b0111111111111;
		x1_im=13'b0000000000000;
		x2_re=13'b0111111111111;
		x2_im=13'b0000000000000;
	end

always #5 clk<=~clk;

endmodule
