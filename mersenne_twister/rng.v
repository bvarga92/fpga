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

	/* utemezes */
	reg[9:0] idx;
	reg init_done;
	reg[11:0] cntr;
	always@(posedge clk)
		if(rst)
		begin
			init_done<=0;
			cntr<=0;
		end
		else if((~init_done)&(cntr==624))
		begin
			init_done<=1;
			cntr<=0;
		end
		else if(start|(cntr==2503))
			cntr<=0;
		else
			cntr<=cntr+1;

	/* blokk RAM a 624 allapotregiszternek */
	(* RAM_EXTRACT="yes", RAM_STYLE="block" *)reg[31:0] mt[0:623];
	reg[9:0] rd_addr;
	reg[31:0] rd_data;
	wire[9:0] wr_addr;
	wire[31:0] wr_data;
	reg wr_en;
	always@(posedge clk)
		if(rst)
			rd_data<=0;
		else
		begin
			if(wr_en) mt[wr_addr]<=wr_data;
			rd_data<=mt[rd_addr];
		end

	/* irasi jelek meghajtasa */
	reg[31:0] wr_data_init, wr_data_gen;
	assign wr_addr=init_done?(cntr[11:2]-1):(cntr-1);
	always@(posedge clk)
		wr_en<=((~init_done)&(cntr<624))|((idx==624)&(~valid)&(cntr[1:0]==2'b11));
	always@(posedge clk) 
		wr_data_init<=(cntr==0)?SEED:({wr_data_init[31:2],wr_data_init[1:0]^wr_data_init[31:30]}*32'h6C078965+cntr);
	assign wr_data=init_done?wr_data_gen:wr_data_init;

	/* olvasasi jelek meghajtasa */
	always@(*)
		if(idx==624)
			if(cntr[11:2]<227)
				case(cntr[1:0])
					0:       rd_addr<=cntr[11:2]+397;
					1:       rd_addr<=cntr[11:2];
					default: rd_addr<=cntr[11:2]+1;
				endcase
			else if(cntr[11:2]<623)
				case(cntr[1:0])
					0:       rd_addr<=cntr[11:2]-227;
					1:       rd_addr<=cntr[11:2];
					default: rd_addr<=cntr[11:2]+1;
				endcase
			else
				case(cntr[1:0])
					0:       rd_addr<=396;
					1:       rd_addr<=623;
					default: rd_addr<=0;
				endcase
		else
			rd_addr<=idx;

	/* generalas */
	reg[63:0] temp;
	reg[31:0] x;
	always@(posedge clk)
		if(rst)
		begin
			idx<=624;
			valid<=0;
		end
		else if(start)
			valid<=0;
		else if(init_done & ~valid)
			if(idx==624)
			begin
				case(cntr[1:0])
					1: temp[63:32]<=rd_data;
					2: temp[31:0]<=rd_data;
					3: wr_data_gen<=temp[63:32]^{1'b0,temp[31],rd_data[30:1]}^(rd_data[0]?32'h9908B0DF:0);
				endcase
				if(cntr==2499) idx<=0;
			end
			else
				case(cntr[1:0])
					0: x<={rd_data[31:21],rd_data[20:0]^rd_data[31:11]};
					1: x[31:7]<=x[31:7]^(x[24:0]&25'h13A58AD);
					2: x[31:15]<=x[31:15]^(x[16:0]&17'h1DF8C);
					3: begin rand_out<={x[31:14],x[13:0]^x[31:18]}; idx<=idx+1; valid<=1; end
				endcase

	task print_mt;
		integer i;
		for(i=0;i<624;i=i+1) $display("%d",mt[i]);
	endtask

endmodule
