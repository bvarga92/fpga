/********************************************************************/
/*                                                                  */
/* 2 csatornas DDS jelgenerator Nexys3 panellel + PmodDA4 modullal. */
/*                                                                  */
/* - A kimeneti frekvencia az SW4-SW7 kapcsolokkal allithato 0 es   */
/*   915.5 Hz kozott.                                               */
/* - A kimeneti jel amplitudoja az SW2-SW3 kapcsolokkal allithato   */
/*   0.625 Vpp es  2.5 Vpp kozott.                                  */
/* - A fazistolas az SW0-SW1 kapcsolokkal allithato 0 es 270 fok    */
/*   kozott.                                                        */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module toplevel(
	input rst, //reset
	input clk, //rendszerorajel (100 MHz)
	input[7:0] sw, //kapcsolok
	output[7:0] led, //LED-ek
	output dac_csn, //DAC Chip Select
	output dac_mosi, //DAC soros bemenet
	output dac_sclk //DAC orajel
);

assign led=sw;

wire dac_start;
wire[11:0] data1, data2;
wire[19:0] freq;
wire[9:0] phase;
wire[11:0] amp;
assign freq={9'd0,sw[7:4],7'd0};
assign phase={sw[1:0],8'd0};
assign amp={sw[3:2],10'd1023};

/* DDS modul */
dds dds_i(
	.rst(rst),
	.clk(clk),
	.freq(freq),
	.phase(phase),
	.amp(amp),
	.dout1(data1),
	.dout2(data2),
	.dac_start(dac_start)
);

/* AD5628 DAC interfesz */
dac dac_i(
	.rst(rst),
	.clk(clk),
	.din1(data1),
	.din2(data2),
	.start(dac_start),
	.csn(dac_csn),
	.mosi(dac_mosi),
	.sclk(dac_sclk)
);

endmodule
