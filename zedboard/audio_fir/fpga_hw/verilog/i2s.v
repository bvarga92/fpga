`timescale 1ns / 1ps

module i2s(
	input AMSCK, //98.304 MHz
	input lrck,
	input bclk,
	input sdin,
	output sdout,
	output mclk,
	input[23:0] din, //DAC bemenet, rd_x jelek utan 5 orajellel stabilnak kell lennie
	output rd_l,
	output rd_r,
	output[23:0] dout, //ADC kimenet, valid_x jelekre mintavetelezheto
	output valid_l,
	output valid_r
);

	/* MCLK: 12.288 MHz */
	reg[2:0] mclk_cntr=0;
	always@(posedge AMSCK)
		mclk_cntr<=mclk_cntr+1;
	assign mclk=mclk_cntr[2];

	/* elek detektalasa */
	reg[1:0] lrck_dl=0;
	always@(posedge AMSCK) lrck_dl<={lrck_dl[0],lrck};
	wire lrck_rise=(lrck_dl==2'b01);
	wire lrck_fall=(lrck_dl==2'b10);
	reg[1:0] bclk_dl=0;
	always@(posedge AMSCK) bclk_dl<={bclk_dl[0],bclk};
	wire bclk_rise=(bclk_dl==2'b01);
	wire bclk_fall=(bclk_dl==2'b10);

	/* ADC bal csatorna */
	reg[31:0] shr_l=0;
	always@(posedge AMSCK)
		if(lrck_rise)
			shr_l<=0;
		else if(lrck&bclk_rise)
			shr_l<={shr_l[30:0],sdin};

	/* ADC jobb csatorna */
	reg[31:0] shr_r=0;
	always@(posedge AMSCK)
		if(lrck_fall)
			shr_r<=0;
		else if((~lrck)&bclk_rise)
			shr_r<={shr_r[30:0],sdin};

	/* ADC adatkimenet */
	reg[23:0] dout_reg=0;
	always@(posedge AMSCK)
		if(lrck_rise)
			dout_reg<=shr_r[23:0];
		else if(lrck_fall)
			dout_reg<=shr_l[23:0];
	assign dout=dout_reg;

	/* ADC valid jelek */
	reg lrck_rise_dl=0;
	always@(posedge AMSCK) lrck_rise_dl<=lrck_rise;
	assign valid_r=lrck_rise_dl;
	reg lrck_fall_dl=0;
	always@(posedge AMSCK) lrck_fall_dl<=lrck_fall;
	assign valid_l=lrck_fall_dl;

	/* DAC  */
	reg[5:0] din_rd_dl;
	always@(posedge AMSCK) din_rd_dl<={din_rd_dl[4:0],rd_r|rd_l};
	reg[31:0] sdout_shr;
	always@(posedge AMSCK)
		if(din_rd_dl[5])
			sdout_shr<={8'd0,din};
		else if(bclk_fall)
			sdout_shr<={sdout_shr[30:0],1'b0};
	assign sdout=sdout_shr[31];

	/* DAC adatkero jelek */
	assign rd_r=lrck_fall;
	assign rd_l=lrck_rise;

endmodule
