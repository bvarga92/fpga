`timescale 1ns / 1ps

module toplevel(
	input clk, // 12 MHz
	input[1:0] btn,
	output[1:0] led,
	output[2:0] rgb
);

	assign led=btn;

	reg[21:0] cntr=22'd0;
	wire en=(cntr==3_999_999);
	always@(posedge clk)
		if(en)
			cntr<=0;
		else
			cntr<=cntr+1;
	
	reg[2:0] rgb_reg=3'b110;
	always@(posedge clk)
		if(en)
			rgb_reg<={rgb_reg[0],rgb_reg[2:1]};
	assign rgb=rgb_reg;

endmodule
