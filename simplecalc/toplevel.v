/**********************************************************************/
/*                                                                    */
/* Az elso operandust a felso 4 kapcsoloval, a masodik operandust     */
/* pedig az also 4 kapcsoloval adhatjuk meg. Ezutan a nyomogombokkal  */
/* valaszthatjuk ki az elvegezni kivant muveletet.                    */
/*                                                                    */
/**********************************************************************/

`timescale 1ns / 1ps

module toplevel(
	input       clk, //100 MHz
	input       rst,
	inout [3:0] btn,
	input [7:0] sw,
	output[7:0] led,
	output[3:0] an,
	output[7:0] seg
);

	/* aritmetikai egysegek */
	wire[4:0] res_add;
	wire sign_add=0;
	add add_i(
		.in1(sw[7:4]),
		.in2(sw[3:0]),
		.out(res_add)
	);

	wire[3:0] res_sub;
	wire sign_sub=(sw[7:4]<sw[3:0]);
	sub sub_i(
		.in1(sw[7:4]),
		.in2(sw[3:0]),
		.out(res_sub)
	);

	wire[7:0] res_mul;
	wire sign_mul=0;
	mul mul_i(
		.clk(clk),
		.rst(rst),
		.in1(sw[7:4]),
		.in2(sw[3:0]),
		.out(res_mul)
	);

	wire[3:0] res_div;
	wire sign_div=0;
	div div_i(
		.clk(clk),
		.rst(rst),
		.in1(sw[7:4]),
		.in2(sw[3:0]),
		.out(res_div)
	);


	/* kimenetvalaszto multiplexer */
	reg[1:0] select;
	always@(posedge clk)
		if(rst)
			select<=0;
		else
			case(btn)
				4'b0001: select<=0;
				4'b0010: select<=1;
				4'b0100: select<=2;
				4'b1000: select<=3;
			endcase

	reg[7:0] res;
	reg sign;
	always@(*)
		case(select)
			0: begin res<={3'd0,res_add}; sign<=sign_add; end
			1: begin res<={4'd0,res_sub}; sign<=sign_sub; end
			2: begin res<=res_mul;        sign<=sign_mul; end
			3: begin res<={4'd0,res_div}; sign<=sign_div; end
		endcase


	/* kijelzes */
	wire[3:0] d2, d1, d0;

	bin2bcd bin2bcd_i(
		.clk(clk),
		.rst(rst),
		.in(res),
		.d2(d2),
		.d1(d1),
		.d0(d0)
	);

	bcd_to_7seg bcd_to_7seg_i(
		.clk(clk),
		.rst(rst),
		.digit0(d0),
		.digit1(d1),
		.digit2(d2),
		.digit3(sign?4'hA:4'hF),
		.an(an),
		.seg(seg)
	);

	assign led=sw;

endmodule
