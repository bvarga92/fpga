/********************************************************************/
/*                                                                  */
/* SPI master vevo a PmodMIC3 panelen talalhato Texas Instruments   */
/* ADCS7476 A/D konverterhez. A mintaveteli frekvencia 48 kHz.      */
/* Miden konverzio veget a data_wr vonalon egy 1 orajel szeles      */
/* impulzus jelzi.                                                  */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module pmodmic3(
	input clk, //98.304 MHz
	input rst,
	output sck,
	output ss,
	input miso,
	output reg[11:0] data,
	output data_wr
);

	/* SPI orajel: 3.072 MHz */
	reg[10:0] cntr;
	always@(posedge clk)
		cntr<=rst?(11'd0):(cntr+1'b1);
	assign sck=ss?1'b1:cntr[4];

	/* Slave Select jel */
	assign ss=~((cntr<544)&(cntr>28));

	/* SCK felfuto ele */
	wire sck_rise=(cntr[4:0]==5'b01111);

	/* a MISO vonal mintavetelezese */
	reg[15:0] shr;
	always@(posedge clk)
		if(rst)
			shr<=16'd0;
		else if((~ss)&sck_rise)
			shr<={shr[14:0],miso};

	/* vetel kesz, adat kiadasa */
	always@(posedge clk)
		if(rst)
			data<=12'd0;
		else if(cntr==543)
			data<=shr[12:1];
	
	/* beiro impulzus kiadasa */
	assign data_wr=(cntr==544);

endmodule
