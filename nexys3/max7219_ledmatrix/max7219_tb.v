`timescale 1ns / 1ps

module max7219_tb;
	reg clk, rst, start;
	reg[15:0] data;
	wire cs, sclk, dout, busy;

	max7219 #(
		.CS_FALL_TO_FIRST_SCLK_RISE(1000),
		.LAST_SCLK_FALL_TO_CS_RISE(1000),
		.CLK_PER_SCLK(100),
		.DATABITS(16)
	) uut(
		.clk(clk),
		.rst(rst),
		.start(start),
		.data(data),
		.cs(cs),
		.sclk(sclk),
		.dout(dout),
		.busy(busy)
	);

	initial begin
		clk=0;
		rst=1;
		start=0;
		#100;
		rst=0;
		#1000;
		data=16'h1234;
		@(posedge clk) start=1;
		@(posedge clk) start=0;
		@(posedge cs) ;
		#1000;
		data=16'h5555;
		@(posedge clk) start=1;
		@(posedge clk) start=0;
	end

	always #5 clk<=~clk;

endmodule
