`timescale 1ns / 1ps

module toplevel(
	input clk,
	input rst,
	output max7219_din,
	output max7219_cs,
	output max7219_sclk
);

	parameter NUM_IMAGES=7;
	parameter CNTR_MAX=199_999_999;
	parameter STARTTIME=999;

	reg[$clog2(CNTR_MAX+1)-1:0] cntr;
	always@(posedge clk)
		if(rst | cntr==CNTR_MAX)
			cntr<=0;
		else
			cntr<=cntr+1;

	wire start=(cntr==STARTTIME);

	reg[15:0] ram_offset;
	always@(posedge clk)
		if(rst)
			ram_offset<=(NUM_IMAGES-1)*13;
		else if(cntr==STARTTIME-1)
			ram_offset<=(ram_offset==(NUM_IMAGES-1)*13)?0:(ram_offset+13);

	ledmtx #(
		.NUM_IMAGES(NUM_IMAGES)
	) ledmtx_i(
		.clk(clk),
		.rst(rst),
		.start(start),
		.ram_offset(ram_offset),
		.max7219_din(max7219_din),
		.max7219_cs(max7219_cs),
		.max7219_sclk(max7219_sclk),
		.busy()
	);

endmodule
