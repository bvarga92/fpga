`timescale 1ns / 1ps

module ledmtx_tb;
	reg clk, rst, start;
	reg[15:0] ram_offset;
	wire max7219_din, max7219_cs, max7219_sclk, busy;

	ledmtx #(
		.NUM_IMAGES(7)
	)uut(
		.clk(clk),
		.rst(rst),
		.start(start),
		.ram_offset(ram_offset),
		.max7219_din(max7219_din),
		.max7219_cs(max7219_cs),
		.max7219_sclk(max7219_sclk),
		.busy(busy)
	);

	initial begin
		clk=0;
		rst=1;
		start=0;
		ram_offset=0;
		#100;
		rst=0;
		#10000;
		@(posedge clk) start=1;
		@(posedge clk) start=0;
		@(negedge busy) ;
		#50000;
		@(posedge clk) start=1; ram_offset=13;
		@(posedge clk) start=0;
		#50000;
		@(posedge clk) start=1; // atvitel kozben start impulzus --> hatastalan
		@(posedge clk) start=0;
	end

	always #5 clk<=~clk;

endmodule
