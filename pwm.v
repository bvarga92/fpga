`timescale 1ns / 1ps

module pwm #(
	parameter CLK_DIV=391,
	parameter CNTR_BITS=8 // f=fclk/(CLK_DIV*2^CNTR_BITS)
)(
	input                   clk,
	input                   rst,
	input  [CNTR_BITS-1:0] duty0, // D=duty/(2^CNTR_BITS-1)
	input  [CNTR_BITS-1:0] duty1,
	input  [CNTR_BITS-1:0] duty2,
	input  [CNTR_BITS-1:0] duty3,
	input  [CNTR_BITS-1:0] duty4,
	input  [CNTR_BITS-1:0] duty5,
	input  [CNTR_BITS-1:0] duty6,
	input  [CNTR_BITS-1:0] duty7,
	output [7:0]           out
);

	reg[$clog2(CLK_DIV)-1:0] q;
	wire en=(q==CLK_DIV-1);
	always@(posedge clk)
		q<=(rst|en)?0:(q+1);

	reg[CNTR_BITS-1:0] cntr;
	always@(posedge clk)
		if(rst)
			cntr<=0;
		else if(en)
			cntr<=cntr+1;

	assign out[0]=(duty0==0)?0:(cntr<=duty0);
	assign out[1]=(duty1==0)?0:(cntr<=duty1);
	assign out[2]=(duty2==0)?0:(cntr<=duty2);
	assign out[3]=(duty3==0)?0:(cntr<=duty3);
	assign out[4]=(duty4==0)?0:(cntr<=duty4);
	assign out[5]=(duty5==0)?0:(cntr<=duty5);
	assign out[6]=(duty6==0)?0:(cntr<=duty6);
	assign out[7]=(duty7==0)?0:(cntr<=duty7);

endmodule
