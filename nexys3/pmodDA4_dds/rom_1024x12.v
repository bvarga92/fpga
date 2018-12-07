/********************************************************************/
/*                                                                  */
/* ROM a jel mintainak tarolasara (Xilinx BRAM).                    */
/*                                                                  */
/* - A tartalom a rom.txt fajlbol inicializalodik.                  */
/* - Szinkron olvasas: a kimenet 1 orajelet kesik a cimhez kepest!  */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module rom_1024x12(
	input clk,
	input[9:0] addr,
	output[11:0] dout
);

(* RAM_EXTRACT="yes", RAM_STYLE="block" *)reg signed [11:0] const_array[1023:0];
initial $readmemh("../../src/rom.txt",const_array);

reg[11:0] dout_reg;
always@(posedge clk)
	dout_reg<=const_array[addr];

assign dout=dout_reg;

endmodule
