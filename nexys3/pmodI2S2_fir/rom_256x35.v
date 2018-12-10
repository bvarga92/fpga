`timescale 1ns / 1ps

module rom_256x35(
	input clk,
	input[7:0] addr,
	output reg[34:0] dout
);

	(* RAM_EXTRACT="yes", RAM_STYLE="block" *)reg signed[34:0] mem[255:0];
	initial $readmemh("./src/coeffs.txt",mem);

	always@(posedge clk)
		dout<=mem[addr];

endmodule
