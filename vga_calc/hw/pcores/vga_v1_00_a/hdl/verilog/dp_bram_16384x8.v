/*************************************************************/
/*                                                           */
/* Dual port Block RAM a frame buffernek                     */
/*                                                           */
/*    - felbontas: 100x75                                    */
/*    - pixel cimzes: 128*sor + oszop                        */
/*    - pixel formatum: rrrgggbb                             */
/*    - a memoria az init.txt fajlbol inicializalodik        */
/*                                                           */
/*************************************************************/

`timescale 1ns / 1ps

module dp_bram_16384x8(
	input clk,
	input rst,
	input wr_en,
	input[13:0] wr_addr,
	input[7:0] wr_data,
	input[13:0] rd_addr,
	output[7:0] rd_data
);

	(* RAM_EXTRACT="yes", RAM_STYLE="block" *)reg[7:0] dp_ram[16383:0];
	initial $readmemh("init.txt",dp_ram);

	reg[7:0] rd_reg;
	always@(posedge clk)
		if(rst)
			rd_reg<=0;
		else
		begin
			if(wr_en) dp_ram[wr_addr]<=wr_data;
			rd_reg<=dp_ram[rd_addr];
		end

	assign rd_data=rd_reg;

endmodule
