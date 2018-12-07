/********************************************************************/
/*                                                                  */
/* Interfesz a PmodAD1 A/D konverter modulhoz.                      */
/*                                                                  */
/*   - Egy orajel hosszu inditoimpulzust kell adni a start          */
/*     bemenetre, ezutan 128 orajel mulva megjelenik a vett adat.   */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module adc(
	input clk,                    //rendszerorajel (100 MHz)
	input rst,                    //reset
	input start,                  //egy orajelnyi triggerimpulzus
	output sck,                   //SPI orajel
	output cs,                    //chip select (alacsony aktiv!)
	input d0,                     //adatbemenet 1
	input d1,                     //adatbemenet 2
	output reg[11:0] dout0, dout1 //itt jelenik meg az adat a konverzio vegen
);

	/* szamlalo az utemezeshez */
	reg busy;
	reg[6:0] cntr;
	always@(posedge clk)
		if(rst|(cntr==7'd127))
			cntr<=0;
		else if(busy)
			cntr<=cntr+1'b1;

	/* statuszregiszter: 1, ha konverzio van folyamatban */
	always@(posedge clk)
		if(rst|(cntr==7'd127))
			busy<=0;
		else if(start)
			busy<=1;

	/* SPI orajel 12.5 MHz */
	assign sck=~cntr[2];

	/* SCLK felfuto el a mintavetelezeshez */
	wire sck_rise;
	assign sck_rise=(cntr[2:0]==3'b111);

	/* chip select */
	assign cs=~((cntr>=2)&&(cntr<=7'd127));

	/* shift regiszterek */
	reg[11:0] shr[0:1];
	always@(posedge clk)
		if(rst)
		begin
			shr[0]<=0;
			shr[1]<=0;
		end
		else if(sck_rise&(cntr>=31)&(cntr<=119))
		begin
			shr[0]<={shr[0][10:0],d0};
			shr[1]<={shr[1][10:0],d1};
		end

	/* ervenyes adat kivagasa */
	always@(posedge clk)
		if(rst)
		begin
			dout0<=0;
			dout1<=0;
		end
		else if(cntr==7'd127)
		begin
			dout0<=shr[0];
			dout1<=shr[1];
		end

endmodule
