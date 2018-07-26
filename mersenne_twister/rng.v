`timescale 1ns / 1ps

module rng #(
	parameter SEED=5489
)(
	input            clk,
	input            rst,
	input            start,
	output reg       valid,
	output reg[31:0] rand_out
);

	reg[9:0] cntr;
	always@(posedge clk)
		cntr<=(rst|start|(cntr==623))?0:(cntr+1);

	reg init_done;
	always@(posedge clk)
		if(rst)
			init_done<=0;
		else if(cntr==623)
			init_done<=1;

	reg[31:0] mt[0:623]; //ez 20 ezer slice FF... esetleg at lehet irni BRAM alapura
	reg[31:0] x;
	reg[9:0] idx;
	always@(posedge clk)
		if(rst)
		begin
			idx<=624;
			valid<=0;
		end
		else if(start)
			valid<=0;
		else if(~init_done)
			if(cntr==0)
				mt[0]<=SEED;
			else
				mt[cntr]<={mt[cntr-1][31:2],mt[cntr-1][1:0]^mt[cntr-1][31:30]}*32'h6C078965+cntr;
		else if(~valid)
			if(idx==624)
					if(cntr<227)
						mt[cntr]<=mt[cntr+397]^{1'b0,mt[cntr][31],mt[cntr+1][30:1]}^(mt[cntr+1][0]?32'h9908B0DF:0);
					else if(cntr<623)
						mt[cntr]<=mt[cntr-227]^{1'b0,mt[cntr][31],mt[cntr+1][30:1]}^(mt[cntr+1][0]?32'h9908B0DF:0);
					else
					begin
						mt[623]<=mt[396]^{1'b0,mt[623][31],mt[0][30:1]}^(mt[0][0]?32'h9908B0DF:0);
						idx<=0;
					end
			else
				case(cntr[1:0])
					0: x<={mt[idx][31:21],mt[idx][20:0]^mt[idx][31:11]};
					1: x[31:7]<=x[31:7]^(x[24:0]&25'h13A58AD);
					2: x[31:15]<=x[31:15]^(x[16:0]&17'h1DF8C);
					3: begin rand_out<={x[31:14],x[13:0]^x[31:18]}; idx<=idx+1; valid<=1; end
				endcase

	task print_mt;
		integer i;
		for(i=0;i<624;i=i+1) $display("%d",mt[i]);
	endtask

endmodule
