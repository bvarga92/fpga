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

	parameter N=624;
	parameter M=397;
	parameter UPPER_MASK='h80000000;
	parameter LOWER_MASK='h7FFFFFFF;
	parameter A='h9908B0DF;
	parameter U=11;
	parameter S=7;
	parameter B='h9D2C5680;
	parameter T=15;
	parameter C='hEFC60000;
	parameter L=18;
	parameter F=1812433253;

	reg[$clog2(N)-1:0] cntr;
	always@(posedge clk)
		cntr<=(rst|start|(cntr==N-1))?0:(cntr+1);

	reg init_done;
	always@(posedge clk)
		if(rst)
			init_done<=0;
		else if(cntr==N-1)
			init_done<=1;

	reg[31:0] mt[0:N-1];
	reg[31:0] x;
	reg[$clog2(N)-1:0] idx;
	always@(posedge clk)
		if(rst)
		begin
			idx<=N;
			valid<=0;
		end
		else if(start)
			valid<=0;
		else if(~init_done)
			if(cntr==0)
				mt[0]<=SEED;
			else
				mt[cntr]<=(mt[cntr-1]^(mt[cntr-1]>>30))*F+cntr;
		else if(~valid)
			if(idx>=N)
				begin
					mt[cntr]<=mt[(cntr+M)%N]^(((mt[cntr]&UPPER_MASK)|(mt[(cntr+1)%N]&LOWER_MASK))>>1)^((mt[(cntr+1)%N]&1)?A:0);
					if(cntr==N-1) idx<=0;
				end
			else
				case(cntr)
					0: x<=mt[idx];
					1: x<=x^(x>>U);
					2: x<=x^((x<<S)&B);
					3: x<=x^((x<<T)&C);
					4: begin rand_out<=x^(x>>L); idx<=idx+1; valid<=1; end
				endcase

	task print_mt;
		integer i;
		for(i=0;i<N;i=i+1) $display("%d",mt[i]);
	endtask

endmodule
