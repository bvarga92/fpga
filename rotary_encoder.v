`timescale 1ns / 1ps

module toplevel(
	input clk, //100 MHz
	input rst,
	input enc_a,
	input enc_b,
	output[7:0] led
);
	 
	/* 1 kHz-es engedelyezojel a mintavetelezeshez */
	reg[16:0] clkdiv;
	wire en;
	assign en=(clkdiv==99_999);
	always@(posedge clk)
		clkdiv<=(rst|en)?0:(clkdiv+1);

	/* mintavetelezes */
	reg[1:0] shr_a, shr_b;
	always@(posedge clk)
		if(rst)
		begin
			shr_a=0;
			shr_b=0;
		end
		else if(en)
		begin
			shr_a={enc_a,shr_a[1]};
			shr_b={enc_b,shr_b[1]};
		end

	/* tekeres detektalasa */
	reg en_dl;
	always@(posedge clk) en_dl<=en;
	wire inc=en_dl&(shr_b==2'b10)&(shr_a[1]==1'b0);
	wire dec=en_dl&(shr_a==2'b10)&(shr_b[1]==1'b0);

	/* szamlalas */
	reg[7:0] cntr;
	always@(posedge clk)
		if(rst)
			cntr<=0;
		else if(inc)
			cntr<=cntr+1;
		else if(dec)
			cntr<=cntr-1;

	/* LED-ek meghajtasa */
	assign led=cntr;

endmodule
