/********************************************************************/
/*                                                                  */
/* A BCD formatumban kapott 4 szamjegyet megjeleniti a kozos anodos */
/* hetszegmenses kijelzokon.                                        */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module bcd_to_7seg(
	input clk,                                 //rendszerorajel (100 MHz)
	input rst,                                 //reset
	input[3:0] digit0, digit1, digit2, digit3, //BCD bemenetek
	output reg[3:0] an,                        //anodjelek
	output reg[7:0] seg                        //szegmensjelek
);
	/* nehany kHz-es engedelyezojel */
	reg[16:0] clk_div;
	always@(posedge clk) clk_div<=rst?(17'd0):(clk_div+1'b1);
	reg clk_div_16_del;
	always@(posedge clk) clk_div_16_del<=clk_div[16];
	reg en;
	always@(posedge clk) en<=rst?(1'b0):(clk_div[16]&(~clk_div_16_del));

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
			4'b1110: dmux<=digit0;
			4'b1101: dmux<=digit1;
			4'b1011: dmux<=digit2;
			4'b0111: dmux<=digit3;
			default: dmux<=4'bxxxx;
		endcase

	/* szegmensdekoder */
	always@(*)
		case(dmux)
			4'd0:    seg<=8'b11000000;
			4'd1:    seg<=8'b11111001;
			4'd2:    seg<=8'b10100100;
			4'd3:    seg<=8'b10110000;
			4'd4:    seg<=8'b10011001;
			4'd5:    seg<=8'b10010010;
			4'd6:    seg<=8'b10000010;
			4'd7:    seg<=8'b11111000;
			4'd8:    seg<=8'b10000000;
			4'd9:    seg<=8'b10010000;
			default: seg<=8'bxxxxxxxx;
		endcase

endmodule
