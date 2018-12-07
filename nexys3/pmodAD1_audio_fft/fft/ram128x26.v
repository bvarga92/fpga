/********************************************************************/
/*                                                                  */
/* Dual-port RAM a mintak tarolasara.                               */
/*                                                                  */
/*   - A 26 bites adatok also 13 bitje a valos resz, a felso 13 bit */
/*     a kepzetes resz.                                             */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module ram128x26(
	input clk_a, we_a, en_a, clk_b, we_b, en_b,
	input[6:0] addr_a, addr_b,
	input[25:0] din_a, din_b,
	output reg[25:0] dout_a, dout_b
);

(* RAM_EXTRACT="yes", RAM_STYLE="block" *)reg[25:0] memory[127:0];

always@(posedge clk_a)
	if(en_a)
	begin
		if(we_a)
			memory[addr_a]<=din_a;
		dout_a<=memory[addr_a];
	end

always@(posedge clk_b)
	if(en_b)
	begin
		if(we_b)
			memory[addr_b]<=din_b;
		dout_b<=memory[addr_b];
	end

endmodule
