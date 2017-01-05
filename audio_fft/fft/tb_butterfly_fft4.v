/********************************************************************/
/*                                                                  */
/* Testbench: 4 pontos FFT manualisan osszedrotozott butterfly      */
/* modulokkal. A kimeneten az amplitudospektrum all elo!            */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module fft4(input clk, input signed [12:0] x0,x1,x2,x3, output signed [12:0] o0,o1,o2,o3);

	/* osszekoto jelek */
	wire signed [12:0] a,b,c,d,e,f,g,h,or0,oi0,or1,oi1,or2,oi2,or3,oi3;

	/* elso fokozat */
	butterfly butterfly_11(
		.clk(clk),
		.w_re(13'b0111111111111), //w=1
		.w_im(13'd0),
		.x1_re(x0),
		.x1_im(13'd0),
		.x2_re(x2),
		.x2_im(13'd0),
		.y1_re(a),
		.y1_im(b),
		.y2_re(c),
		.y2_im(d)
	);
	butterfly butterfly_12(
		.clk(clk),
		.w_re(13'b0111111111111), //w=1
		.w_im(13'd0),
		.x1_re(x1),
		.x1_im(13'd0),
		.x2_re(x3),
		.x2_im(13'd0),
		.y1_re(e),
		.y1_im(f),
		.y2_re(g),
		.y2_im(h)
	);

	/* masodik fokozat */
	butterfly butterfly_21(
		.clk(clk),
		.w_re(13'b0111111111111), //w=1
		.w_im(13'd0),
		.x1_re(a),
		.x1_im(b),
		.x2_re(e),
		.x2_im(f),
		.y1_re(or0),
		.y1_im(oi0),
		.y2_re(or2),
		.y2_im(oi2)
	);
	butterfly butterfly_22(
		.clk(clk),
		.w_re(13'd0),
		.w_im(13'b1000000000000), //w=-j
		.x1_re(c),
		.x1_im(d),
		.x2_re(g),
		.x2_im(h),
		.y1_re(or1),
		.y1_im(oi1),
		.y2_re(or3),
		.y2_im(oi3)
	);

	/* abszolutertek kepzese a kimeneten */
	abs abs_0(
		.y_re(or0),
		.y_im(oi0),
		.y_abs(o0)
	);
	abs abs_1(
		.y_re(or1),
		.y_im(oi1),
		.y_abs(o1)
	);
	abs abs_2(
		.y_re(or2),
		.y_im(oi2),
		.y_abs(o2)
	);
	abs abs_3(
		.y_re(or3),
		.y_im(oi3),
		.y_abs(o3)
	);

endmodule

module tb_butterfly_fft4;

	/* bemenetek */
	reg clk;
	reg signed [12:0] x0, x1, x2, x3;

	/* kimenetek */
	wire signed [12:0] o0, o1, o2, o3;

	fft4 uut(clk,x0,x1,x2,x3,o0,o1,o2,o3);
	
	initial begin
		clk=0;
		/* [0.125 0.125 0.125 0.125]  -->  [0.125 0 0 0] */
		x0=13'b0001000000000;
		x1=13'b0001000000000;
		x2=13'b0001000000000;
		x3=13'b0001000000000;
		#100;
		/* [1 1 1 1]  -->  [1 0 0 0] */
		x0=13'b0111111111111;
		x1=13'b0111111111111;
		x2=13'b0111111111111;
		x3=13'b0111111111111;
		#100;
		/* [0.5 0.25 0.5 0.25]  -->  [0.375 0 0.125 0] */
		x0=13'b0100000000000;
		x1=13'b0010000000000;
		x2=13'b0100000000000;
		x3=13'b0010000000000;
		#100;
		/* [1 0.5 0.25 1]  -->  [0.6875 0.2253 0.0625 0.2253] */
		x0=13'b0111111111111;
		x1=13'b0100000000000;
		x2=13'b0010000000000;
		x3=13'b0111111111111;
	end

always #5 clk<=~clk;

endmodule
