`timescale 1ns / 1ps

module toplevel(
	input clk, //16 MHz
	input rst,
	output[7:0] led
);
	 
	/* orajeloszto */
	reg[19:0] clkdiv;
	wire en;
	assign en=(clkdiv==999_999);
	always@(posedge clk)
		clkdiv<=(rst|en)?0:(clkdiv+1);

	reg[7:0] shr;

	/* iranyvaltas */
	reg dir;
	always@(posedge clk)
		if(rst|(shr==8'b00000001))
			dir<=0;
		else if(shr==8'b10000000)
			dir<=1;
			
	/* leptetes */
	always@(posedge clk)
		if(rst)
			shr<=8'b00000001;
		else if(en)
			shr<=dir?{1'b0,shr[7:1]}:{shr[6:0],1'b0};

	/* LED-ek meghajtasa */
	assign led=shr;

endmodule
