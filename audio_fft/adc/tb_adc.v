/********************************************************************/
/*                                                                  */
/* Testbench a PmodAD1 modulhoz.                                    */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module tb_adc;

	reg clk, rst, start, d0, d1;
	wire sck, cs;
	wire[11:0] dout0, dout1;

	adc uut(
		.clk(clk), 
		.rst(rst), 
		.start(start),
		.sck(sck), 
		.cs(cs), 
		.d0(d0), 
		.d1(d1),
		.dout0(dout0),
		.dout1(dout1)
	);

	integer i;
	reg[11:0] data[0:1];
	initial begin
		clk=0;
		rst=1;
		start=0;
		d0=0;
		d1=0;
		#100;
		rst=0;
		#75;
		start=1;
		#10;
		start=0;
		#10;
		d0=0;
		d1=0;
		data[0]=12'b110011001100;
		data[1]=12'b001100110011;
		#20;
		for(i=0;i<15;i=i+1)
		begin
			d0=(i<3)?0:data[0][14-i];
			d1=(i<3)?0:data[1][14-i];
			#80;
		end
		#1500;
		start=1;
		#10;
		start=0;
		#10;
		d0=0;
		d1=0;
		data[0]=12'b101010101010;
		data[1]=12'b111111000000;
		#20;
		for(i=0;i<15;i=i+1)
		begin
			d0=(i<3)?0:data[0][14-i];
			d1=(i<3)?0:data[1][14-i];
			#80;
		end
	end
	
	always #5 clk=~clk;
      
endmodule
