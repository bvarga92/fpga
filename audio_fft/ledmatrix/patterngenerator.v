/*****************************************************************************/
/*                                                                           */
/* Az FFT egyutthatoknak megfelelo mintaval tolti fel a frame buffert.       */
/*                                                                           */
/*   - az 5 bites (0-16 ertektartomanyu) egyutthatok az in vektorban vannak  */
/*     folytonosan tarolva (mert Verilog modul bemenete nem lehet tomb)      */
/*   - a vektor elso eleme az utolso egyutthato                              */
/*   - a colorsel bemenettel szinsemat lehet valasztani                      */
/*                                                                           */
/*****************************************************************************/

`timescale 1ns / 1ps

module patterngenerator(
	input clk,                  //rendszerorajel
	input rst,                  //reset
	input start,                //beiras inditasa
	input ledmtx_done,          //a LED matrix kirajzolta a frame buffert 
	input[2:0] colorsel,        //szinvalaszto
	input[319:0] in,            //64x5 bitbemenet
	output fb_wr_en,            //frame buffer iras engedelyezes
	output reg[8:0] fb_wr_addr, //frame buffer irasi cim
	output[23:0] fb_wr_data,    //frame buffer irasi adat
	output busy                 //beiras folyamatban
);

	/* szinvalaszto multiplexer */
	reg[11:0] color;
	always@(colorsel)
	begin
		case(colorsel)
			3'b000: color<=12'h500; //kek
			3'b001: color<=12'h005; //piros
			3'b010: color<=12'h050; //zold
			3'b011: color<=12'h505; //lila
			3'b100: color<=12'h550; //turkiz
			3'b101: color<=12'h055; //sarga
			3'b110: color<=12'h025; //narancs
			3'b111: color<=12'h555; //feher
		endcase
	end

	/* statuszregiszter */
	parameter IDLE=2'b00;
	parameter BUSY=2'b01;
	parameter PENDING=2'b11;
	reg[1:0] state;
	always@(posedge clk)
		if(rst|(fb_wr_addr==9'b111111111))
			state<=IDLE;
		else if(start|(state==PENDING))
			if(ledmtx_done)
				state<=BUSY;
			else
				state<=PENDING;
	
	assign busy=(state==BUSY);

	/* cim */
	always@(posedge clk)
		if(rst)
			fb_wr_addr<=0;
		else if(busy)
			fb_wr_addr<=fb_wr_addr+1'b1;
	
	/* adat */
	assign fb_wr_data[11:0]=({in[fb_wr_addr[5:0]*5+4],in[fb_wr_addr[5:0]*5+3],in[fb_wr_addr[5:0]*5+2],
	                          in[fb_wr_addr[5:0]*5+1],in[fb_wr_addr[5:0]*5]}>fb_wr_addr[8:6])?(color):(12'd0); //also sor
	assign fb_wr_data[23:12]=({in[fb_wr_addr[5:0]*5+4],in[fb_wr_addr[5:0]*5+3],in[fb_wr_addr[5:0]*5+2],
	                           in[fb_wr_addr[5:0]*5+1],in[fb_wr_addr[5:0]*5]}>fb_wr_addr[8:6]+8)?(color):(12'd0); //felso sor

	/* beiro jel */
	assign fb_wr_en=busy;

endmodule
