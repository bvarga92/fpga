/********************************************************************/
/*                                                                  */
/* A fenymero szenzorbol olvasott erteket megjeleniti a             */
/* hetszegmenses kijelzokon es a LED-eken. A PmodALS modult az A    */
/* port felso reszebe kell csatlakoztatni.                          */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module toplevel(
	input clk,       //rendszerorajel (100 MHz)
	input rst,       //reset
	input sdo,       //adat a szenzortol
	output cs,       //szenzor Chip Select
	output sck,      //szenzor orajel
	output[7:0] led, //LED-ek
	output[3:0] an,  //anodjelek
	output[7:0] seg  //szegmensjelek
);
	
	wire[7:0] data;
	wire[3:0] digit0, digit1, digit2;

	spi spi_i(
		.clk(clk),
		.rst(rst),
		.miso(sdo),
		.sclk(sck),
		.ss(cs),
		.data(data)
	);
	
	bin_to_bcd bin_to_bcd_i(
		.clk(clk),
		.rst(rst),
		.din(data),
		.digit2(digit2),
		.digit1(digit1),
		.digit0(digit0)
	);
	
	bcd_to_7seg bcd_to_7seg_i(
		.clk(clk),
		.rst(rst),
		.digit0(digit0),
		.digit1(digit1),
		.digit2(digit2),
		.digit3(4'b0000),
		.an(an),
		.seg(seg)
	);
	
	assign led=data;

endmodule
