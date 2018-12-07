/********************************************************************/
/*                                                                  */
/* A PmodMIC3 jelenek atjatszasa a PmodI2S mindket csatornajara.    */
/* A mintaveteli frekvencia 48 kHz.                                 */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module toplevel(
	input clk100, //100 MHz
	input rst,
	output[7:0] led,
	output mic_sck,
	output mic_ss,
	input mic_miso,
	output i2s_mclk,
	output i2s_lrck,
	output i2s_sck,
	output i2s_sdin
);

	/* orajelgenerator: 100 MHz --> 98.304 MHz */
	wire clk;
	clk_gen clk_gen_i(
		.clk_in(clk100),
		.clk_out(clk)
	);

	/* mikrofon bemenet */
	wire[11:0] mic_data;
	pmodmic3 pmodmic3_i(
		.clk(clk),
		.rst(rst),
		.sck(mic_sck),
		.ss(mic_ss),
		.miso(mic_miso),
		.data(mic_data),
		.data_wr()
	);
	assign led=mic_data[11:4];
	
	/* I2S kimenet */
	pmodi2s pmodi2s_i(
		.clk(clk),
		.rst(rst),
		.data_l({1'b0,mic_data,11'd0}),
		.data_r({1'b0,mic_data,11'd0}),
		.mclk(i2s_mclk),
		.lrck(i2s_lrck),
		.sck(i2s_sck),
		.sdin(i2s_sdin),
		.data_rd()
	);

endmodule
