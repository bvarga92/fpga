/*****************************************************************************/
/*                                                                           */
/* Audio spektrumanalizator LED matrix kijelzovel.                           */
/*                                                                           */
/*   - Az SW0-SW2 kapcsolokkal lehet szint valasztani.                       */
/*   - Az SW5 kapcsoloval valaszthato a mintaveteli frekvencia 40 kHz es     */
/*     20 kHz kozott.                                                        */
/*   - Az SW6 kapcsoloval kikapcsolhato a DC szint (a bemenet DC-csatolt).   */
/*   - Az SW7 kapcsoloval kikapcsolhato a kijelzo.                           */
/*                                                                           */
/*****************************************************************************/

`timescale 1ns / 1ps

module toplevel(
	input rst,                  //reset
	input clk,                  //rendszerorajel (100 MHz)
	input[7:0] sw,              //kapcsolok
	output[7:0] led,            //LED-ek
	output[2:0] ledmtx_rowaddr, //LED matrix sorkivalaszto jel
	output ledmtx_clk,          //LED matrix orajel
	output ledmtx_oe,           //LED matrix output enable
	output ledmtx_lat,          //LED matrix latch
	output ledmtx_r1,           //LED matrix also sor piros
	output ledmtx_g1,           //LED matrix also sor zold
	output ledmtx_b1,           //LED matrix also sor kek
	output ledmtx_r2,           //LED matrix felso sor piros
	output ledmtx_g2,           //LED matrix felso sor zold
	output ledmtx_b2,           //LED matrix felso sor kek
	output adc_sck,             //ADC orajel
	output adc_cs,              //ADC chip select
	input adc_d0, adc_d1,       //ADC adat
	output debug                //oszcilloszkoppal lehet figyelni az idoziteseket
);

	/* a LED-eken a kapcsolok allapotat jelenitjuk meg */
	assign led=sw;

	/* led matrix vezerlo */
	wire[8:0] ledmtx_addr;
	wire[23:0] ledmtx_data;
	wire ledmtx_done;
	ledmtx ledmtx_i(
		.clk(clk),
		.rst(rst),
		.enn(sw[7]),
		.rowaddr(ledmtx_rowaddr),
		.sclk(ledmtx_clk),
		.oe(ledmtx_oe),
		.lat(ledmtx_lat),
		.r1(ledmtx_r1),
		.g1(ledmtx_g1),
		.b1(ledmtx_b1),
		.r2(ledmtx_r2),
		.g2(ledmtx_g2),
		.b2(ledmtx_b2),
		.ram_addr(ledmtx_addr),
		.ram_data(ledmtx_data),
		.done(ledmtx_done)
	);
	
	/* kezdokep */
	wire[23:0] init_rd_data;
	ram512x23 init_ram(
		.clk(clk),
		.rst(rst),
		.wr_en(1'b0),
		.wr_addr(9'd0),
		.wr_data(24'd0),
		.rd_addr(ledmtx_addr),
		.rd_data(init_rd_data)
	);

	/* frame buffer */
	wire fb_wr_en;
	wire[8:0] fb_wr_addr;
	wire[23:0] fb_wr_data, fb_rd_data;
	ram512x23 framebuffer(
		.clk(clk),
		.rst(rst),
		.wr_en(fb_wr_en),
		.wr_addr(fb_wr_addr),
		.wr_data(fb_wr_data),
		.rd_addr(ledmtx_addr),
		.rd_data(fb_rd_data)
	);

	/* egy rovid ideig csak a feliratot latjuk */
	reg[27:0] initcntr;
	always@(posedge clk)
		if(rst)
			initcntr<=0;
		else if(~(&initcntr))
			initcntr<=initcntr+1'b1;
	assign ledmtx_data=(&initcntr)?fb_rd_data:init_rd_data;

	/* mintagenerator */
	wire[319:0] in;
	wire pg_start, pg_busy;
	patterngenerator patterngenerator_i(
		.clk(clk),
		.rst(rst),
		.start(pg_start),
		.ledmtx_done(ledmtx_done),
		.colorsel(sw[2:0]),
		.in(in),
		.fb_wr_en(fb_wr_en),
		.fb_wr_addr(fb_wr_addr),
		.fb_wr_data(fb_wr_data),
		.busy(pg_busy)
	);

	/* adc */
	wire[11:0] adc_dout;
	wire adc_start;
	adc adc_i(
		.clk(clk), 
		.rst(rst), 
		.start(adc_start),
		.sck(adc_sck), 
		.cs(adc_cs), 
		.d0(adc_d0), 
		.d1(adc_d1),
		.dout0(adc_dout), //csak a 0-s csatornat hasznaljuk
		.dout1()
	);

	/* mintatar */
	reg sampleram_we_a, sampleram_we_b;
	reg[6:0] sampleram_addr_a, sampleram_addr_b;
	reg[25:0] sampleram_din_a, sampleram_din_b;
	wire[25:0] sampleram_dout_a, sampleram_dout_b;
	ram128x26 sample_ram(
		.clk_a(clk),
		.we_a(sampleram_we_a),
		.en_a(1'b1),
		.clk_b(clk),
		.we_b(sampleram_we_b),
		.en_b(1'b1),
		.addr_a(sampleram_addr_a),
		.addr_b(sampleram_addr_b),
		.din_a(sampleram_din_a),
		.din_b(sampleram_din_b),
		.dout_a(sampleram_dout_a),
		.dout_b(sampleram_dout_b)
	);

	/* FFT egyseg */
	wire fft_we_a, fft_we_b, fft_start, fft_busy;
	wire[6:0] fft_addr_a, fft_addr_b;
	wire[25:0] fft_din_a, fft_din_b;
	fft128 fft(
		.clk(clk),
		.rst(rst),
		.ram_we_a(fft_we_a),
		.ram_we_b(fft_we_b),
		.ram_addr_a(fft_addr_a),
		.ram_addr_b(fft_addr_b),
		.ram_din_a(fft_din_a),
		.ram_din_b(fft_din_b),
		.ram_dout_a(sampleram_dout_a),
		.ram_dout_b(sampleram_dout_b),
		.start(fft_start),
		.busy(fft_busy)
	);

	/* bitsorrend-fordito */
	reg[6:0] sample_cntr;
	wire[6:0] sample_cntr_rev;
	bitreverse bitreverse_i(sample_cntr,sample_cntr_rev);

	/* utemezes */
	reg[4:0] data[0:63];
	reg[12:0] cntr;
	always@(posedge clk)
		if(rst)
		begin
			cntr<=0;
			sample_cntr<=0;
		end
		else if(cntr==(sw[5]?4999:2499))
		begin
			cntr<=0;
			sample_cntr<=sample_cntr+1'b1;
		end
		else
			cntr<=cntr+1'b1;
	
	assign adc_start=(cntr==0);
	assign fft_start=((sample_cntr==127)&(cntr==150));
	assign pg_start=((sample_cntr==127)&(cntr==1720));

	always@(posedge clk)
		if((sample_cntr==127)&&(cntr>=1651)&&(cntr<=1714))
			data[cntr-1651]<=sampleram_dout_a[11:7];

	/* multiplexer a memoria bemeneteihez */
	always@(*)
		if((sample_cntr<127)|(cntr<145)) //irjuk a mintakat a memoriaba (bitreverse cimzessel)
		begin
			sampleram_we_a<=(cntr==140);
			sampleram_we_b<=0;
			sampleram_addr_a<=sample_cntr_rev;
			sampleram_addr_b<=0;
			sampleram_din_a<={14'd0,adc_dout};
			sampleram_din_b<=0;
		end
		else if((sample_cntr==127)&(cntr>=145)&(cntr<1640)) //az FFT modul dolgozik a memoria tartalman
		begin
			sampleram_we_a<=fft_we_a;
			sampleram_we_b<=fft_we_b;
			sampleram_addr_a<=fft_addr_a;
			sampleram_addr_b<=fft_addr_b;
			sampleram_din_a<=fft_din_a;
			sampleram_din_b<=fft_din_b;
		end
		else //olvassuk a transzformacio eredmenyet
		begin
			sampleram_we_a<=0;
			sampleram_we_b<=0;
			sampleram_addr_a<=cntr-12'd1650;
			sampleram_addr_b<=0;
			sampleram_din_a<=0;
			sampleram_din_b<=0;
		end

	/* a kiolvasott ertekeket atadjuk a mintageneratornak */
	genvar i;
	generate
		for(i=0;i<63;i=i+1)
		begin: ram_asgn
			assign in[(i*5+4):(i*5)]=data[63-i];
		end
	endgenerate
	assign in[319:315]=(sw[6])?(5'd0):(data[0]);
	
	/* szkoppal ellenorizhetjuk az utemezest */
	assign debug=adc_start|fft_busy|pg_busy;

endmodule
