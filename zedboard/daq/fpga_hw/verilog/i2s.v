`timescale 1ns / 1ps

module i2s(
	input AMSCK, //98.304 MHz
	input lrck,
	input bclk,
	input sdin,
	output sdout,
	output mclk,
	output[23:0] dout,
	output valid_l,
	output valid_r
);

	/* MCLK: 12.288 MHz */
	reg[2:0] mclk_cntr=0;
	always@(posedge AMSCK)
		mclk_cntr<=mclk_cntr+1;
	assign mclk=mclk_cntr[2];

	/* loopback */
	assign sdout=sdin;

	/* elek detektalasa */
	reg[1:0] lrck_dl=0;
	always@(posedge AMSCK) lrck_dl<={lrck_dl[0],lrck};
	wire lrck_rise=(lrck_dl==2'b01);
	wire lrck_fall=(lrck_dl==2'b10);
	reg[1:0] bclk_dl=0;
	always@(posedge AMSCK) bclk_dl<={bclk_dl[0],bclk};
	wire bclk_rise=(bclk_dl==2'b01);

	/* bal csatorna */
	reg[31:0] shr_l=0;
	always@(posedge AMSCK)
		if(lrck_rise)
			shr_l<=0;
		else if(lrck&bclk_rise)
			shr_l<={shr_l[30:0],sdin};

	/* jobb csatorna */
	reg[31:0] shr_r=0;
	always@(posedge AMSCK)
		if(lrck_fall)
			shr_r<=0;
		else if((~lrck)&bclk_rise)
			shr_r<={shr_r[30:0],sdin};

	/* adatkimenet */
	reg[23:0] dout_reg=0;
	always@(posedge AMSCK)
		if(lrck_rise)
			dout_reg<=shr_r[23:0];
		else if(lrck_fall)
			dout_reg<=shr_l[23:0];
	assign dout=dout_reg;

	/* valid jelek */
	reg lrck_rise_dl=0;
	always@(posedge AMSCK) lrck_rise_dl<=lrck_rise;
	assign valid_r=lrck_rise_dl;
	reg lrck_fall_dl=0;
	always@(posedge AMSCK) lrck_fall_dl<=lrck_fall;
	assign valid_l=lrck_fall_dl;

endmodule
