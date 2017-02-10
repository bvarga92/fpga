`timescale 1ns / 1ps

module pmodi2s_tb;
	reg clk;
	reg rst;
	reg[23:0] data_l;
	reg[23:0] data_r;

	wire mclk;
	wire lrck;
	wire sck;
	wire sdin;
	wire data_rd;

	pmodi2s uut(
		.clk(clk), 
		.rst(rst),
		.data_l(data_l),
		.data_r(data_r),
		.mclk(mclk), 
		.lrck(lrck), 
		.sck(sck), 
		.sdin(sdin),
		.data_rd(data_rd)
	);

	initial begin
		clk=0;
		rst=1;
		data_l=24'hFFFFFF;
		data_r=24'h000000;
		#100;
		rst=0;
	end

	always #5 clk<=~clk;
	
endmodule

