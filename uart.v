/*****************************************************************/
/*                                                               */
/* UART ado, 115200 bps, 8O1 mod                                 */
/*                                                               */
/* Az atvitelt a start bemenetre adott 1 orajel hosszusagu       */
/* impulzussal lehet inditani. Az adatbemenet latchelt, igy adas */
/* kozben is megvaltoztathato. A felhasznalo dolga ellenorizni,  */
/* hogy adas kozben ne jojjon start impulzus.                    */
/*                                                               */
/*****************************************************************/

`timescale 1ns / 1ps

module uart(
	input clk,       //orajel (100 MHz)
	input rst,       //reset
	input[7:0] data, //kuldendo adat
	input start,     //adasindito impulzus
	output tx_out    //UART kimenet
);

	reg[3:0] tx_cntr; //hanyadik bitet kuldjuk ki

	/* allapotgep */
	reg busy;
	always@(posedge clk)
		if(rst|(tx_cntr==11))
			busy<=0;
		else if(start)
			busy<=1;

	/* bemenet latchelese */
	reg[7:0] data_lat;
	always@(posedge clk)
		if(rst)
			data_lat<=0;
		else if(start)
			data_lat<=data;

	/* engedelyezo impulzus 115207.4 bps-hez */
	wire tx_en;
	reg[9:0] cntr;
	always@(posedge clk)
		if(rst|(~busy))
			cntr<=10'd866;
		else if(busy)
			cntr<=tx_en?(10'd0):(cntr+1'b1);
	assign tx_en=(cntr==867);

	/* elkuldott bitek szamolasa */
	always@(posedge clk)
		if(rst|(tx_cntr==11))
			tx_cntr<=0;
		else if(tx_en)
			tx_cntr<=tx_cntr+1'b1;

	/* shift regiszter */
	reg[10:0] tx_shr;
	always@(posedge clk)
		if(rst)
			tx_shr<=11'b11111111111;
		else if(tx_en)
			if(tx_cntr==0)
				tx_shr<={1'b1,~(^data_lat),data_lat,1'b0};
			else
				tx_shr<={1'b1,tx_shr[10:1]};

	assign tx_out=tx_shr[0];

endmodule
