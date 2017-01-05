`timescale 1ns / 1ps

module toplevel(
	input clk, //16 MHz
	input rst,
	input[7:0] sw,
	output[7:0] led
);
	 
	/* orajeloszto */
	reg[23:0] clkdiv;
	wire en;
	assign en=(clkdiv==15_999_999);
	always@(posedge clk)
		clkdiv<=(rst|en)?0:(clkdiv+1);

	/* also digit */
	reg[3:0] cntr1;
	always@(posedge clk)
		if(rst)
			cntr1<=0;
		else if(en)
			if(sw[0])
				cntr1<=(cntr1==0)?9:(cntr1-1);
			else
				cntr1<=(cntr1==9)?0:(cntr1+1);
			
	/* felso digit */
	reg[2:0] cntr2;
	always@(posedge clk)
		if(rst)
			cntr2<=0;
		else if(en&sw[0]&(cntr1==0))
			cntr2<=(cntr2==0)?5:(cntr2-1);
		else if(en&~sw[0]&(cntr1==9))
			cntr2<=(cntr2==5)?0:(cntr2+1);

	/* LED-ek meghajtasa */
	assign led={1'b0,cntr2,cntr1};

endmodule
