/********************************************************************/
/*                                                                  */
/* Testbench a DDS modulhoz.                                        */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module tb_dds;
	/* bemenetek */
	reg rst;
	reg clk;
	reg[19:0] freq;
	reg[9:0] phase;
	reg[11:0] amp;

	/* kimenetek */
	wire[11:0] dout1, dout2;
	wire dac_start;

	dds uut(
		.rst(rst), 
		.clk(clk), 
		.freq(freq),
		.phase(phase),
		.amp(amp),
		.dout1(dout1),
		.dout2(dout2), 
		.dac_start(dac_start)
	);

	initial begin
		/* reset */
		rst=1;
		clk=0;
		freq=2621;
		phase=100;
		amp=4095; //max amplitudo --> mul_out=rom_dout
		#100;
		/* reset vissza */
		rst=0;
	end

always #5 clk<=~clk; //orajel

endmodule
