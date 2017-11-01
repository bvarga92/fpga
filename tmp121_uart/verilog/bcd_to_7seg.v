`timescale 1ns / 1ps

module bcd_to_7seg(
	input clk,
	input rst,
	input[3:0] din0,
	input[3:0] din1,
	input[3:0] din2,
	input[3:0] din3,
	output reg[3:0] an,
	output[7:0] seg
);

	/* 1.53 kHz-es engedelyezojel a digitek leptetesehez */
	reg[16:0] cntr;
	wire en=cntr[16];
	always@(posedge clk)
		cntr<=(rst|en)?0:(cntr+1);

	/* anodjel */
	always@(posedge clk)
		if(rst)
			an<=4'b1110;
		else if(en)
			an<={an[2:0],an[3]};

	/* multiplexer a digit kivalasztasahoz */
	reg[3:0] dmux;
	always@(*)
		case(an)
			4'b1110: dmux<=din0;
			4'b1101: dmux<=din1;
			4'b1011: dmux<=din2;
			4'b0111: dmux<=din3;
			default: dmux<=4'bxxxx;
	endcase

	/* szegmensdekoder */
	reg[6:0] seg_r;
	always@(*)
		case(dmux)
			4'h0:    seg_r<=7'b1000000;
			4'h1:    seg_r<=7'b1111001;
			4'h2:    seg_r<=7'b0100100;
			4'h3:    seg_r<=7'b0110000;
			4'h4:    seg_r<=7'b0011001;
			4'h5:    seg_r<=7'b0010010;
			4'h6:    seg_r<=7'b0000010;
			4'h7:    seg_r<=7'b1111000;
			4'h8:    seg_r<=7'b0000000;
			4'h9:    seg_r<=7'b0010000;
			4'hA:    seg_r<=7'b0111111; //- jel
			default: seg_r<=7'b1111111;
	endcase
	
	/* 3. kijelzo tizedespontja bekapcsolva */
	assign seg={an[1],seg_r};

endmodule
