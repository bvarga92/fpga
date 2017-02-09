/********************************************************************/
/*                                                                  */
/* Ketcsatornas DDS modul.                                          */
/*                                                                  */
/* - A mintaveteli frekvenica a rendszerorajel 200-ad resze.        */
/* - Az akkumulator 20 bites, a felso 10 bit cimzi a mintatarat,    */
/*   tehat osszesen 1024 darab 12 bites mintat tarolunk a jelbol.   */
/* - 100 MHz rendszerorajel mellett a felbontas 0.477 Hz.           */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module dds(
	input rst, //reset
	input clk, //rendszerorajel (fclk=100MHz --> fs=500kHz)
	input[19:0] freq, //frekvenciaregiszter (fki=fs*freq/(2^20))
	input[9:0] phase, //fazisregiszter (fazistolas=2*pi*phase/1024)
	input[11:0] amp, //amplitudoregiszter (0: kikapcs, 4095: max amplitudo)
	output reg[11:0] dout1, //adatkimenet 1
	output reg[11:0] dout2, //adatkimenet 2
	output dac_start //egy orajelnyi impulzus a DAC-nak
);

/* engedelyezojel generalasa (fs=fclk/200) */
reg[7:0] clk_div;
reg en;
always@(posedge clk)
	clk_div<=(rst|en)?(8'd0):(clk_div+1'b1);
always@(posedge clk)
	en<=(clk_div==8'd198);

/* fazisakkumulalas */
reg[19:0] accu;
always@(posedge clk)
	if(rst)
		accu<=0;
	else if(en)
		accu<=accu+freq;

/* en impulzus kesleltetese */
reg[4:0] en_dl;
always@(posedge clk)
	en_dl<=rst?(5'b0000):{en_dl[3:0],en};

/* cimzes */
wire[9:0] addr;
assign addr=en_dl[0]?accu[19:10]:accu[19:10]+phase;

/* ROM a jelforma mintainak tarolasara (BRAM) */
wire[11:0] rom_dout;
rom_1024x12 sample_rom(
	.clk(clk),
	.addr(addr),
	.dout(rom_dout)
);

/* amplitudo szorzasa: elojel nelkuli, fixpontos szamokkent tekintunk rajuk:
        a: 1.12 (jel a tortresz)
        b: 1.12 (amplitudoregiszter+1)
        p: 2.24 (kimenet a tortresz felso 12 bitje --> nem tud tulcsordulni)
*/
wire[17:0] a,b;
wire[35:0] p;
wire[11:0] mul_out;
assign a=rom_dout;
assign b=amp+1'b1;
assign mul_out=p[23:12];

mul mul_i(
	.clk(clk),
	.rst(rst),
	.a(a),
	.b(b),
	.p(p)
);

/* dout1 az en impulzus utan 3 orajellel jelenik meg */
always@(posedge clk)
	if(rst)
		dout1<=0;
	else if(en_dl[2])
		dout1<=mul_out;

/* dout2 az en impulzus utan 4 orajellel jelenik meg */
always@(posedge clk)
	if(rst)
		dout2<=0;
	else if(en_dl[3])
		dout2<=mul_out;

/* en impulzus utan 5 orajellel stabil mindket adat, akkor adjuk a start jelet */
assign dac_start=en_dl[4];

endmodule
