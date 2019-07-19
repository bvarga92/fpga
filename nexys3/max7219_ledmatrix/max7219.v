`timescale 1ns / 1ps

module max7219 #(
	parameter CS_FALL_TO_FIRST_SCLK_RISE=1000,
	parameter LAST_SCLK_FALL_TO_CS_RISE=1000,
	parameter CLK_PER_SCLK=100,
	parameter DATABITS=16
)(
	input clk,
	input rst,
	input start,
	input[DATABITS-1:0] data,
	output reg cs,
	output reg sclk,
	output reg dout,
	output reg busy
);

	/* szamlalo az utemezeshez */
	parameter CNTR_MAX=CS_FALL_TO_FIRST_SCLK_RISE-CLK_PER_SCLK/2+DATABITS*CLK_PER_SCLK+LAST_SCLK_FALL_TO_CS_RISE-1;
	reg[$clog2(CNTR_MAX+1)-1:0] cntr;
	always@(posedge clk)
		if(rst | cntr==CNTR_MAX)
			cntr<=0;
		else if(busy)
			cntr<=cntr+1;

	/* statuszregiszter */
	always@(posedge clk)
		if(rst | cntr==CNTR_MAX)
			busy<=0;
		else if(start)
			busy<=1;

	/* chip select jel generalasa */
	always@(posedge clk)
		if(rst | cntr==CNTR_MAX)
			cs<=1;
		else if(start & ~busy)
			cs<=0;

	/* sclk generalasa */
	reg[$clog2(CLK_PER_SCLK)-1:0] cntr2;
	wire sclk_fall=(cntr2==CLK_PER_SCLK-1 | cntr==CS_FALL_TO_FIRST_SCLK_RISE-CLK_PER_SCLK/2-1);
	wire sclk_rise=(cntr2==CLK_PER_SCLK/2-1);
	always@(posedge clk)
		if(rst | sclk_fall | cntr<CS_FALL_TO_FIRST_SCLK_RISE-CLK_PER_SCLK/2-1 | cntr>CS_FALL_TO_FIRST_SCLK_RISE-CLK_PER_SCLK/2+DATABITS*CLK_PER_SCLK-1)
			cntr2<=0;
		else if(busy)
			cntr2<=cntr2+1;

	always@(posedge clk)
		if(rst|sclk_fall)
			sclk<=0;
		else if(sclk_rise)
			sclk<=1;

	/* adatbitek kiadasa */
	reg[$clog2(DATABITS)-1:0] bitcntr;
	always@(posedge clk)
		if(rst | cntr==CS_FALL_TO_FIRST_SCLK_RISE-CLK_PER_SCLK/2+DATABITS*CLK_PER_SCLK-1)
		begin
			bitcntr<=DATABITS-1;
			dout<=0;
		end
		else if(sclk_fall)
		begin
			bitcntr<=bitcntr-1;
			dout<=data[bitcntr];
		end

endmodule
