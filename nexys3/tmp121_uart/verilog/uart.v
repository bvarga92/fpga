/********************************************************************************/
/*                                                                              */
/*  UART ado, folyamatosan kuldi a bemenetekre BCD kodolassal adott szamjegyek  */
/*  ASCII kodjait \r karakterrel lezarva, 7O2 modban, 38400 bps baudrate-tel.   */
/*                                                                              */
/********************************************************************************/

`timescale 1ns / 1ps

module uart(
	input clk,
	input rst,
	input[3:0] bcd0,
	input[3:0] bcd1,
	output tx_out
);

	/* baudrate: 100 MHz / 2604 = 38402.46 bps (64 ppm hiba) */
	wire tx_en;
	reg[11:0] q;
	always@(posedge clk)
		q<=(rst|tx_en)?0:(q+1);
	assign tx_en=(q==2603);

	/* kikuldott bitek szamlalasa (0-32) */
	reg[5:0] tx_cntr;
	always@(posedge clk)
		if(rst)
			tx_cntr<=32;
		else if(tx_en)
			tx_cntr<=(tx_cntr==32)?0:(tx_cntr+1);

	/* 33 bites shift regiszter, ebben lesz a kuldendo adat */
	reg[32:0] tx_shr;
	always@(posedge clk)
		if(rst)
			tx_shr<=33'h1FFFFFFFF;
		else if(tx_en)
			if(tx_cntr==32)
			begin
				tx_shr[0]<=0;                 //startbit1
				tx_shr[7:1]<={3'b011,bcd1};   //adat1
				tx_shr[8]<=~^bcd1;            //paritas1
				tx_shr[10:9]<=2'b11;          //stopbit1
				tx_shr[11]<=0;                //startbit2
				tx_shr[18:12]<={3'b011,bcd0}; //adat2
				tx_shr[19]<=~^bcd0;           //paritas2
				tx_shr[21:20]<=2'b11;         //stopbit2
				tx_shr[22]<=0;                //startbit3
				tx_shr[29:23]<=7'h0D;         //adat3 (kocsivissza)
				tx_shr[30]<=0;                //paritas3
				tx_shr[32:31]<=2'b11;         //stopbit3
			end
			else
				tx_shr<={1'b1,tx_shr[32:1]};

	/* adatvonal meghajtasa */
	assign tx_out=tx_shr[0];

endmodule
