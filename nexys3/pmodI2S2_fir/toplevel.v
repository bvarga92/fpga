`timescale 1ns / 1ps

module toplevel(
	input clk100, //100 MHz
	input rst,
	output dac_mclk,
	output dac_lrck,
	output dac_sclk,
	output dac_sdata,
	output adc_mclk,
	output adc_lrck,
	output adc_sclk,
	input adc_sdata
);

	wire clk, mclk, lrck, sclk, dac_rd_adc_wr, fir_out_valid;
	wire[23:0] dac_l, adc_l, right, fir_out;

	clk_gen clk_gen_i(
		.clk_in(clk100),
		.clk_out(clk)
	);

	srl_fifo fifo_dac_L(
		.clk(clk),
		.rst(rst),
		.wr(fir_out_valid),
		.rd(dac_rd_adc_wr),
		.din(fir_out),
		.dout(dac_l),
		.empty(),
		.full()
	);

	pmodi2s2 codec(
		.clk(clk),
		.rst(rst),
		.mclk(mclk),
		.lrck(lrck),
		.sclk(sclk),
		.dac_l(dac_l),
		.dac_r(right),
		.dac_sdata(dac_sdata),
		.adc_sdata(adc_sdata),
		.adc_l(adc_l),
		.adc_r(right),
		.dac_rd_adc_wr(dac_rd_adc_wr)
	);

	assign adc_mclk=mclk;
	assign dac_mclk=mclk;
	assign adc_sclk=sclk;
	assign dac_sclk=sclk;
	assign adc_lrck=lrck;
	assign dac_lrck=lrck;

	fir fir_l(
		.clk(clk),
		.rst(rst),
		.din(adc_l),
		.din_valid(dac_rd_adc_wr),
		.dout(fir_out),
		.dout_valid(fir_out_valid)
	);

endmodule
