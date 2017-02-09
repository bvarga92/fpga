/********************************************************************/
/*                                                                  */
/* Testbench az AD5628 D/A konverterhez.                            */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module tb_dac;
	/* bemenetek */
	reg rst;
	reg clk;
	reg[11:0] din1;
	reg[11:0] din2;
	reg start;

	/* kimenetek */
	wire csn;
	wire mosi;
	wire sclk;

	dac uut(
		.rst(rst),
		.clk(clk),
		.din1(din1),
		.din2(din2),
		.start(start),
		.csn(csn),
		.mosi(mosi),
		.sclk(sclk)
	);

	initial begin
		/* reset */
		rst=1;
		clk=0;
		din1=12'b000000000000;
		din2=12'b000000000000;
		start=0;
		#100;
		/* reset vissza */
		rst=0;
		#206;
		/* start pulzus --> 0x08000001, 0x02100000 */
		start=1;
		#10;
		start=0;
		#300;
		/* start pulzus --> hatastalan, meg tart az elozo atvitel */
		din1=12'b111111111111;
		din2=12'b111111111111;
		start=1;
		#10;
		start=0;
		#2000;
		/* start pulzus --> 0x000AAA00, 0x021AAA00 */
		din1=12'b101010101010;
		din2=12'b101010101010;
		start=1;
		#10;
		start=0;
		#2000;
		/* start pulzus --> 0x00055500, 0x02100100 */
		din1=12'b010101010101;
		din2=12'b000000000001;
		start=1;
		#10;
		start=0;
	end

	always #5 clk<=~clk; //orajel
      
endmodule
