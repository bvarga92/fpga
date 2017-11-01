`timescale 1ns / 1ps

module tb_spi_temp;

	reg clk, rst;
	wire miso, csn, sck;
	wire[12:0] dout;
	wire[15:0] spi_data=16'h1234;
	reg[3:0] bit_cntr=15;

	spi uut(
		.clk(clk), 
		.rst(rst), 
		.csn(csn), 
		.sck(sck), 
		.miso(miso), 
		.dout(dout)
	);

	initial begin
		clk=0;
		rst=1;
		#102;
		rst=0;
	end
	
	always #5 clk<=~clk;
	always@(negedge csn) bit_cntr<=15;
	always@(negedge sck) if(~csn) bit_cntr<=bit_cntr-1;
	assign miso=spi_data[bit_cntr];

endmodule
