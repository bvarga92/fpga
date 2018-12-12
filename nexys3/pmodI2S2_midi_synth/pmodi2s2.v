/***********************************************************************/
/*                                                                     */
/* I2S vezerlo a PmodI2S2 audio modulhoz. Az adatok 24 bitesek, a      */
/* mintaveteli frekvencia 48 kHz. Az adatbemeneteket a dac_rd_adc_wr   */
/* impulzus utani masodik orajelre mintavetelezzuk, az adatkimeneteket */
/* ezzel a jellel egyutt frissitjuk, es a kovetkezo utemig kitartjuk   */
/* (tehat tudunk BRAM-ot, FIFO-t es hasonlokat kezelni).               */
/*                                                                     */
/***********************************************************************/

`timescale 1ns / 1ps

module pmodi2s2(
	input clk,   //98.304 MHz
	input rst,
	output mclk, //12.288 MHz
	output lrck, //48 kHz
	output sclk, //3.072 MHz
	input[23:0] dac_l,
	input[23:0] dac_r,
	output dac_sdata,
	input adc_sdata,
	output reg[23:0] adc_l,
	output reg[23:0] adc_r,
	output dac_rd_adc_wr
);

	/* I2S orajelek eloallitasa */
	reg[10:0] cntr;
	always@(posedge clk)
		cntr<=rst?(11'd0):(cntr+1'b1);
	assign mclk=cntr[2];
	assign lrck=cntr[10];
	assign sclk=cntr[4];

	/* SCLK fel- es lefuto ele */
	wire sclk_rise=(cntr[4:0]==5'b01111);
	wire sclk_fall=(cntr[4:0]==5'b11111);

	/* adat kiadasa a DAC-nak */
	reg[63:0] dac_shr;
	always@(posedge clk)
		if(rst|(cntr==0))
			dac_shr<={1'b0, dac_l, 8'd0, dac_r, 7'd0};
		else if(sclk_fall)
			dac_shr<={dac_shr[62:0], 1'b0};
	assign dac_sdata=dac_shr[63];

	/* adat beolvasasa az ADC-tol */
	reg[63:0] adc_shr;
	always@(posedge clk)
		if(rst)
			adc_shr<=24'd0;
		else if(sclk_rise)
			adc_shr<={adc_shr[62:0], adc_sdata};

	always@(posedge clk)
		if(rst|(cntr==2046))
		begin
			adc_l<=adc_shr[62:39];
			adc_r<=adc_shr[30:7];
		end

	/* dac_rd_adc_wr impulzus */
	assign dac_rd_adc_wr=&cntr;

endmodule
