`timescale 1ns / 1ps

module i2s_tb;
	reg AMSCK;
	reg lrck;
	reg bclk;
	reg sdin;
	wire sdout;
	wire mclk;
	wire[23:0] dout;
	wire valid_l;
	wire valid_r;

	i2s uut(
		.AMSCK(AMSCK), 
		.lrck(lrck), 
		.bclk(bclk), 
		.sdin(sdin), 
		.sdout(sdout), 
		.mclk(mclk), 
		.dout(dout), 
		.valid_l(valid_l),
		.valid_r(valid_r)
	);

	wire[23:0] data1_l=24'h885511;
	wire[23:0] data1_r=24'h123456;
	wire[23:0] data2_l=24'h654321;
	wire[23:0] data2_r=24'h40724F;
	integer i;

	initial begin
		AMSCK=0;
		lrck=1;
		bclk=0;
		sdin=0;
		#20;
		@(posedge lrck)
			for(i=30;i>=0;i=i-1)
				@(negedge bclk) sdin=(i>23)?0:data1_l[i];
		@(negedge lrck)
			for(i=30;i>=0;i=i-1)
				@(negedge bclk) sdin=(i>23)?0:data1_r[i];
		@(posedge lrck)
			for(i=30;i>=0;i=i-1)
				@(negedge bclk) sdin=(i>23)?0:data2_l[i];
		@(negedge lrck)
			for(i=30;i>=0;i=i-1)
				@(negedge bclk) sdin=(i>23)?0:data2_r[i];
	end

	always #5 AMSCK<=~AMSCK;
	always #80 bclk<=~bclk;
	always #5120 lrck<=~lrck;

endmodule
