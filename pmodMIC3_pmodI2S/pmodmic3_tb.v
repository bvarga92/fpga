`timescale 1ns / 1ps

module pmodmic3_tb;
	reg clk;
	reg rst;
	reg miso;

	wire sck;
	wire ss;
	wire[11:0] data;
	wire data_wr;

	pmodmic3 uut(
		.clk(clk), 
		.rst(rst), 
		.sck(sck), 
		.ss(ss), 
		.miso(miso), 
		.data(data),
		.data_wr(data_wr)
	);

	integer i;
	wire[11:0] testdata1=12'h813;
	wire[11:0] testdata2=12'h7B8;

	initial begin
		clk=0;
		rst=1;
		miso=0;
		#100;
		rst=0;
		for(i=0;i<16;i=i+1)
			@(negedge sck) miso=((i<3)||(i==15))?0:testdata1[14-i];
		for(i=0;i<16;i=i+1)
			@(negedge sck) miso=((i<3)||(i==15))?0:testdata2[14-i];
	end
	
	always #5 clk<=~clk;
      
endmodule
