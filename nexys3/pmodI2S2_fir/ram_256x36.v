`timescale 1ns / 1ps

module ram_256x36(
	input clk_a,
	input we_a,
	input[7:0] addr_a,
	input[35:0] din_a,
	output reg[35:0] dout_a,
	input clk_b,
	input we_b,
	input[7:0] addr_b,
	input[35:0] din_b,
	output reg[35:0] dout_b
);

	(* RAM_EXTRACT="yes", RAM_STYLE="block" *)reg[35:0] mem[255:0];
	integer i;
	initial
		for(i=0; i<256; i=i+1) mem[i]=0;

	always@(posedge clk_a)
	begin
		if(we_a) mem[addr_a]<=din_a;
		dout_a<=mem[addr_a];
	end

	always@(posedge clk_b)
	begin
		if(we_b) mem[addr_b]<=din_b;
		dout_b<=mem[addr_b];
	end

endmodule
