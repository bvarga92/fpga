/*************************************************************/
/*                                                           */
/* VGA meghajto periferia                                    */
/*                                                           */
/*    - idozites: 800x600 @ 60 Hz                            */
/*                                                           */
/*************************************************************/

module vga(
	input clk,
	input rst,
	output[9:0] row,
	output[9:0] col,
	input[11:0] fb_data,
	output hsync,
	output vsync,
	output[11:0] rgb
);

	/* 50 MHz-es pixel engedelyezo jel */
	reg en;
	always@(posedge clk) en<=rst?0:~en;

	/* sorszinkron */
	reg[10:0] hcnt;
	always@(posedge clk)
		if(rst)
			hcnt<=0;
		else if(en)
			hcnt<=(hcnt==1039)?(11'd0):(hcnt+1'b1);
	assign hsync=(hcnt<856)|(hcnt>975);

	/* kepszinkron */
	reg[9:0] vcnt;
	always@(posedge clk)
		if(rst)
			vcnt<=0;
		else if(en&(hcnt==1039))
			vcnt<=(vcnt==665)?(10'd0):(vcnt+1'b1);
	assign vsync=(vcnt<637)|(vcnt>642);

	/* ha teljes felbontast akarunk, akkor a cimzes: 800*sor+oszlop */
	assign row=(vcnt<600)?vcnt:(10'd0);
	assign col=(hcnt<800)?hcnt:(10'd0);
	
	/* szinjelek meghajtasa */
	reg valid;
	always@(posedge clk) valid<=((hcnt<800)&(vcnt<600));
	assign rgb=(rst|(~valid))?(12'd0):fb_data;

endmodule
