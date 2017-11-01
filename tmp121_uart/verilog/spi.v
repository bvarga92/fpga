`timescale 1ns / 1ps

module spi(
	input clk,
	input rst,
	output reg csn,
	output sck,
	input miso,
	output reg[12:0] dout
);

//szamlalo az utemezeshez (26 bit --> frissites 671 ms-onkent)
reg[25:0] cntr;
always@(posedge clk)
	cntr<=rst?0:(cntr+1);

//3.125 MHz-es SPI orajel es a felfuto ele
assign sck=cntr[4];
wire sck_rise=(cntr[4:0]==5'b01111);

//alacsony aktiv Chip Select jel
always@(posedge clk)
	if(rst|(cntr==543))
		csn<=1;
	else if(cntr==31)
		csn<=0;

//shift regiszter az adatok vetelere
reg[15:0] shr;
always@(posedge clk)
	if(sck_rise&~csn)
		shr<={shr[14:0],miso};

//az ervenyes adat a shift regiszter felso 13 bitje
always@(posedge clk)
	if(rst)
		dout<=0;
	else if(csn)
		dout<=shr[15:3];

endmodule
