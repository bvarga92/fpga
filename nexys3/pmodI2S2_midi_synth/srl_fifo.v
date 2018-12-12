`timescale 1ns / 1ps

module srl_fifo(
	input clk,
	input rst,
	input wr,
	input rd,
	input[15:0] din,
	output[15:0] dout,
	output empty,
	output full
);

	integer i;
	reg[15:0] srl_shr[15:0];
	always@(posedge clk)
		if(wr)
		begin
			for(i=15; i>0; i=i-1)
				srl_shr[i]<=srl_shr[i-1];
			srl_shr[0]<=din;
		end

	reg[4:0] dcnt;
	always@(posedge clk)
		if(rst)
			dcnt<=0;
		else
			if(wr & ~rd)
				dcnt<=dcnt+1;
			else if(~wr & rd)
				dcnt<=dcnt-1;

	reg[4:0] addr;
	always@(posedge clk)
		if(rst)
			addr<=5'h1F;
		else
			if(wr & ~rd)
				addr<=addr+1;
			else if(~wr & rd)
				addr<=addr-1;

	assign empty=addr[4];
	assign full=dcnt[4];		
	assign dout=srl_shr[addr[3:0]];

endmodule
