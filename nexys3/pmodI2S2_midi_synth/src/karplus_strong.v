`timescale 1ns / 1ps

module karplus_strong(
	input clk,
	input rst,
	input start, //ide kell adni egy impulzust, ha mintat akarunk generalni
	input newnote, //ha a start impulzus kozben ez 1, akkor uj pengetes, kulonben folytatodik az elozo hang
	input[10:0] length, //a shift regiszter hossza, ez hatarozza meg a hang frekvenciajat
	output reg signed[23:0] dout,
	output reg dout_valid
);

	/* az inicializalo ertekeket tarolo ROM */
	(* RAM_EXTRACT="yes", RAM_STYLE="block" *)reg signed[23:0] init_rom[1744:0];
	initial $readmemh("./src/init.txt",init_rom);

	reg signed[23:0] init_data;
	reg[10:0] init_addr;

	always@(posedge clk)
		init_data<=init_rom[init_addr];


	/* a cirkularis buffert megvalosito RAM */
	(* RAM_EXTRACT="yes", RAM_STYLE="block" *)reg signed[23:0] ram[1744:0];
	initial $readmemh("./src/init.txt",ram);

	reg[10:0] rd_addr, wr_addr;
	reg signed[23:0] rd_data, wr_data;
	reg wr_en;

	always@(posedge clk)
		if(rst)
			rd_data<=0;
		else begin
			if(wr_en) ram[wr_addr]<=wr_data;
			rd_data<=ram[rd_addr];
		end


	/* allapotregiszter */
	reg[1:0] state;

	parameter STATE_IDLE=0;
	parameter STATE_INIT=1;
	parameter STATE_INIT_DONE=2;
	parameter STATE_WORK=3;

	always@(posedge clk)
		if(rst)
			state<=STATE_IDLE;
		else if(start & state==STATE_IDLE)
			state<=newnote?STATE_INIT:STATE_WORK;
		else if(state==STATE_WORK & wr_en)
			state<=STATE_IDLE;
		else if(state==STATE_INIT & wr_addr==1743)
			state<=STATE_INIT_DONE;
		else if(state==STATE_INIT_DONE)
			state<=STATE_WORK;


	/* uj minta szamitasa */
	reg signed[23:0] dl;	
	always@(posedge clk)
		if(rst | (state==STATE_IDLE & start & newnote)) begin
			dl<=0;
			rd_addr<=0;
			dout_valid<=0;
			wr_en<=newnote;
			init_addr<=0;
			wr_addr<=0;
		end
		else if(state==STATE_WORK & ~wr_en) begin //a hang kovetkezo mintajanak szamitasa
			dout<=(rd_data>>>1)+(dl>>>1);
			dl<=rd_data;
			rd_addr<=(rd_addr==length-1)?0:(rd_addr+1);
			wr_data<=(rd_data>>>1)+(dl>>>1);
			wr_addr<=rd_addr;
			wr_en<=1;
			dout_valid<=1;
		end
		else if(state==STATE_WORK & wr_en) begin //szamitas kesz
			wr_en<=0;
			dout_valid<=0;
		end
		else if(state==STATE_INIT) begin //uj hang, inicializaljuk a memoriat
			wr_data<=init_data;
			init_addr<=init_addr+1;
			wr_addr<=(init_addr==0)?0:(init_addr-1);
		end
		else if(state==STATE_INIT_DONE) //inicializalas kesz
			wr_en<=0;

endmodule
