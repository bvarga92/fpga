`timescale 1ns / 1ps

module midi_rx(
	input clk, //100 MHz
	input rst,
	input rx,
	output reg[7:0] rx_byte,
	output rx_byte_valid
);

	/* regiszterezzuk az adatvonalat */
	reg[1:0] rx_dl;
	always@(posedge clk)
		if(rst)
			rx_dl<=0;
		else
			rx_dl<={rx_dl[0], rx};

	/* allapotregiszter: 1, ha vetel kozben vagyunk */
	reg state;
	reg[14:0] clk_cntr;
	always@(posedge clk)
		if(rst | (state==1 & clk_cntr>30400))
			state<=0;
		else if(state==0 & rx_dl==2'b10)
			state<=1;

	/* orajelszamlalo */
	always@(posedge clk)
		if(rst | (state==0 & rx_dl==2'b10))
			clk_cntr<=0;
		else
			clk_cntr<=clk_cntr+1;

	/* a bitek kozepenel mintavetelezunk (TODO: javitani lehetne tobbsegi szavazassal) */
	integer i;
	reg[9:0] rx_data;
	always@(posedge clk)
		for(i=0; i<10; i=i+1)
			if(clk_cntr==1599+3200*i) rx_data[i]<=rx_dl[0];

	/* a kimenet ervenyes, ha a start es a stop bit a helyen van */
	always@(posedge clk)
		if(rst)
			rx_byte<=0;
		else if(clk_cntr==30400 & rx_data[0]==1'b0 & rx_data[9]==1'b1)
			rx_byte<=rx_data[8:1];

	assign rx_byte_valid=(clk_cntr==30401 & rx_data[0]==1'b0 & rx_data[9]==1'b1);

endmodule
