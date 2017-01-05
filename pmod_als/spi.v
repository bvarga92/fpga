/********************************************************************/
/*                                                                  */
/* SPI master vevo a Texas Instruments ADC081S021 tipusu A/D        */
/* konverterhez illesztett Vishay TEMT6000X01 megvilagitasmerohoz.  */
/* SCLK felfuto elere mintavetelezunk, masodercenkent 10-szer       */
/* olvassuk ki az adatot az ADC-bol.                                */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module spi(
	input clk,           //rendszerorajel (100 MHz)
	input rst,           //reset
	input miso,          //SPI adatbemenet
	output sclk,         //SPI orajel
	output reg ss,       //SPI Slave Select (low active)
	output reg[7:0] data //a legutobbi vett adat
);

	/* 100 MHz-es rendszerorajelbol 3.125 MHz-es SCLK orajel */
	reg[23:0] cntr;
	always@(posedge clk)
		cntr<=(rst|(cntr==24'd9_999_999))?(24'd0):(cntr+1'b1);
	assign sclk=ss?1'b1:cntr[4];
	
	/* SCLK felfuto ele */
	wire sclk_rise=(cntr[4:0]==5'b01111);

	/* Slave Select jel generalasa */
	always@(posedge clk)
		if(rst|(cntr==24'd543))
			ss<=1'b1;
		else if(cntr==24'd31)
			ss<=1'b0;

	/* shift regiszter a beerkezo adatok fogadasara */
	reg[15:0] shr;
	always@(posedge clk)
		if(rst)
			shr<=16'd0;
		else if((~ss)&sclk_rise)
			shr<={shr[14:0],miso};

	/* az ADC hasznos adata a kozepso 8 bit */
	always@(posedge clk)
		if(rst)
			data<=8'd0;
		else if(ss)
			data<=shr[11:4];

endmodule
