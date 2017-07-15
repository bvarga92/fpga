`timescale 1ns / 1ps

module cam_capture_tb;
	reg clk;
	reg rst;
	reg pclk;
	reg vsync;
	reg href;
	reg [7:0] data;

	wire [8:0] row;
	wire [9:0] col;
	wire [14:0] rgb555;
	wire valid;

	cam_capture uut(
		.clk(clk), 
		.rst(rst), 
		.pclk(pclk), 
		.vsync(vsync), 
		.href(href), 
		.data(data), 
		.row(row), 
		.col(col), 
		.rgb555(rgb555), 
		.valid(valid)
	);

	initial begin
		clk=0;
		rst=1;
		pclk=0;
		vsync=0;
		href=0;
		data=0;
		#100;
		rst=0;
	end

	always #5 clk<=~clk;
	always #25 pclk<=~pclk;
	always #1000
		begin
			#1;
			href<=1;
			#64000;
			href<=0;
		end
	always@(negedge pclk) data=data+1;

endmodule
