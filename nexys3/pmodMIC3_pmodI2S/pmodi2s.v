/********************************************************************/
/*                                                                  */
/* I2S vezerlo a PmodI2S audio modulhoz. Az adatok 24 bitesek, a    */
/* mintaveteli frekvencia 48 kHz. Az adatbemeneteket a data_rd      */
/* impulzus utani masodik orajelre mintavetelezzuk (tehat tudunk    */
/* BRAM-bol, FIFO-bol es hasonlokbol olvasni).                      */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module pmodi2s(
	input clk, //98.304 MHz
	input rst,
	input[23:0] data_l,
	input[23:0] data_r,
	output mclk, //12.288 MHz
	output lrck, //48 kHz
	output sck, //3.072 MHz
	output sdin,
	output data_rd
);

	/* I2S orajelek eloallitasa */
	reg[10:0] cntr;
	always@(posedge clk)
		cntr<=rst?(11'd0):(cntr+1'b1);
	assign mclk=cntr[2];
	assign lrck=cntr[10];
	assign sck=cntr[4];

	/* SCK lefuto ele */
	wire sck_fall=(cntr[4:0]==5'b11111);

	/* adat kiadasa */
	reg[63:0] shr;
	always@(posedge clk)
		if(rst|(cntr==0))
			shr={1'b0, data_l, 8'd0, data_r, 7'd0};
		else if(sck_fall)
			shr={shr[62:0],1'b0};
	assign sdin=shr[63];
	
	/* data_rd impulzus */
	assign data_rd=&cntr;

endmodule
