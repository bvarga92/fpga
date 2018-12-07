/*************************************************************/
/*                                                           */
/* 16 mely SRL FIFO a vett karaktereknek                     */
/*                                                           */
/*************************************************************/

`timescale 1ns / 1ps

module fifo16(
	input clk,
	input rst,
	input wr,
	input rd,
	input[7:0] din,
	output[7:0] dout,
	output empty,
	output full
);

	/* shift regiszter */
	integer i;
	reg[7:0] shr[15:0];
	always@(posedge clk)
		if(wr) begin
			for(i=15;i>0;i=i-1) begin
				shr[i]<=shr[i-1];
			end
				shr[0]<=din;
		end

	/* adat szamlalo */
	reg[4:0] cntr;
	always@(posedge clk)
		if(rst)
			cntr<=0;
		else
			if(wr&~rd)
				cntr<=cntr+1'b1;
			else if(rd&~wr)
				cntr<=cntr-1'b1;

	/* statuszjelek */
	assign empty=(cntr==0);
	assign full=cntr[4];

	/* kimenet cimzese */
	reg[3:0] addr;
	always@(posedge clk)
		if(rst)
			addr<=4'd15;
		else
			if(wr&~rd)
				addr<=addr+1'b1;
			else if(rd&~wr)
				addr<=addr-1'b1;
	assign dout=shr[addr];

endmodule
