/********************************************************************/
/*                                                                  */
/* Interfesz az AD5628 D/A konverterhez.                            */
/*                                                                  */
/* - A mintaveteli frekvenciat a start impulzusok gyakorisaga       */
/*   hatarozza meg, legfeljebb fclk/140 lehet.                      */
/* - Az adatbemenet a start impulzus utan 1 orajellel latchelodik,  */
/*   a kimenetek pedig a start impulzus 136 orajellel frissulnek.   */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module dac(
	input rst, //reset
	input clk, //rendszerorajel (100 MHz)
	input[11:0] din1, //adatbemenet (A csatorna)
	input[11:0] din2, //adatbemenet (B csatorna)
	input start, //egy orajelnyi inditoimpulzus (max 714 kHz)
	output csn, //SPI engedelyezo jel
	output mosi, //SPI adat
	output sclk //SPI orajel (50 MHz)
);

/* start impulzusra elmentjuk a bemeneteket */
reg[11:0] din1_lat, din2_lat;
always@(posedge clk)
	if(rst)
	begin
		din1_lat<=0;
		din2_lat<=0;
	end
	else if(start & ~transfer)
	begin
		din1_lat<=din1;
		din2_lat<=din2;
	end
	
/* jelzi, hogy eppen mintat kuldunk a DAC fele */
reg transfer;
always@(posedge clk)
	if(rst|(cntr==8'd139))
		transfer<=0;
	else if(start)
		transfer<=1;

/* szamlalo az utemezeshez */
reg[7:0] cntr;
always@(posedge clk)
	if(rst|(cntr==8'd139))
		cntr<=0;
	else if(transfer)
		cntr<=cntr+1'b1;

/* 50 MHz SPI orajel */
assign sclk=cntr[0];

/* CS alacsony, amkor atvitel van */
assign csn=~(((cntr>=8'd1) & (cntr<=8'd64)) | ((cntr>=8'd71) & (cntr<=8'd134)));

/* jelzi, hogy kesz vagyunk-e a felkonfiguralassal */
reg config_done;
always@(posedge clk)
	if(rst)
		config_done<=0;
	else if(cntr==8'd64)
		config_done<=1'b1;

/* SCLK felfuto elere adjuk ki az uj adatot, lefutora mintavetelez */
reg[31:0] shr;
always@(posedge clk)
	if(rst)
		shr<=0;
	else if(cntr==0)
		if(!config_done)
			shr<=32'h08000001; //elso parancs: belso referenciafeszultseg be (2.5 V)
		else
			shr<={
				4'b0000, //don't care
				4'b0000, //parancs (iras a bemeneti regiszterbe)
				4'b0000, //cim (A csatorna)
				din1_lat, //adat
				8'b00000000 //don't care
			};
	else if(cntr==8'd70)
			shr<={
				4'b0000, //don't care
				4'b0010, //parancs (iras a bemeneti regiszterbe es minden kimenet frissitese)
				4'b0001, //cim (B csatorna)
				din2_lat, //adat
				8'b00000000 //don't care
			};
	else if(cntr[0]==1'b0)
		shr<={shr[30:0],1'b0};

assign mosi=shr[31];

endmodule
