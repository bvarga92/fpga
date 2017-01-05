/*****************************************************************************/
/*                                                                           */
/* Dual-port RAM a frame buffernek.                                          */
/*                                                                           */
/*   - szinkron iras es olvasas, READ_FIRST mode                             */
/*   - minden cimen 6x4 bit van: [B2][G2][R2][B1][G1][R1]                    */
/*   - a 0 cim az also sor jobb oldali pixelet jelenti                       */
/*   - a cim minden sorban jobbrol balra novekszik                           */
/*   - a memoria az init.txt fajl tartalmaval inicializalodik                */
/*                                                                           */
/*****************************************************************************/

`timescale 1ns / 1ps

module ram512x23(
	input clk,           //rendszerorajel
	input rst,           //reset
	input wr_en,         //iras engedelyezes
	input[8:0] wr_addr,  //irasi cim
	input[23:0] wr_data, //beirando adat
	input[8:0] rd_addr,  //olvasasi cim
	output[23:0] rd_data //kiolvasott adat
);

(* RAM_EXTRACT="yes", RAM_STYLE="block" *)reg[23:0] dp_ram[511:0];
initial $readmemh("../../src/ledmatrix/init.txt",dp_ram);

reg[23:0] rd_reg;
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
