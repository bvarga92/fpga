/********************************************************************/
/*                                                                  */
/* A bemenetkent kapott 8 bites, elojel nelkuli szamot BCD          */
/* formatumba konvertalja szekvencialisan, tobb orajel alatt. (Van  */
/* ennel sokkal jobb megoldas is).                                  */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module bin_to_bcd(
	input clk,                             //rendszerorajel
	input rst,                             //reset
	input[7:0] din,                        //a bemeneti 8 bites, elojel nelkuli szam
	output reg[3:0] digit2, digit1, digit0 //a kimeneti helyiertekek BCD formatumban
);

	reg[7:0] data_old;
	reg[7:0] data_conv;
	reg[3:0] tens;
	reg[1:0] hundreds;

	always@(posedge clk)
		if((din!=data_old)|rst) //latcheljuk a bemenetet
		begin
			data_old<=din;
			data_conv<=din;
			tens<=0;
			hundreds<=0;
			if(rst)
			begin
				digit2<=4'd0;
				digit1<=4'd0;
				digit0<=4'd0;
			end
		end
		else if(data_conv>8'd99) //megszamoljuk, hanyszor tudunk belole levonni 100-at
		begin
			data_conv<=data_conv-8'd100;
			hundreds<=hundreds+1'b1;
		end
		else if(data_conv>8'd9) //majd megszamoljuk, hanyszor tudunk belole levonni 10-et
		begin
			data_conv<=data_conv-8'd10;
			tens<=tens+1'b1;
		end
		else //keszen vagyunk
		begin
			digit2<={2'b00,hundreds};
			digit1<=tens;
			digit0<=data_conv[3:0];
		end

endmodule
