`timescale 1ns / 1ps

module toplevel(
	input clk, //100 MHz
	input rst,
	input[7:0] sw,
	output[7:0] led,
	output[3:0] an,
	output[7:0] seg,
	input tmp_miso,
	output tmp_csn,
	output tmp_sck,
	output uart_tx
);

	wire[12:0] tmp_dout;

	spi spi_i(
		.clk(clk),
		.rst(rst),
		.csn(tmp_csn),
		.sck(tmp_sck),
		.miso(tmp_miso),
		.dout(tmp_dout)
	);

	wire[3:0] bcd_sign, bcd_msd, bcd_lsd, bcd_fract;

	temp_to_bcd temp_to_bcd_i(
		.clk(clk),
		.rst(rst),
		.temp(tmp_dout),
		.sw(sw),
		.d3(bcd_sign),
		.d2(bcd_msd),
		.d1(bcd_lsd),
		.d0(bcd_fract)
	 );

	bcd_to_7seg bcd_to_7seg_i(
		.clk(clk),
		.rst(rst),
		.din0(bcd_fract),
		.din1(bcd_lsd),
		.din2(bcd_msd),
		.din3(bcd_sign),
		.an(an),
		.seg(seg)
	);

	uart uart_i(
		.clk(clk),
		.rst(rst),
		.bcd0(bcd_lsd),
		.bcd1(bcd_msd),
		.tx_out(uart_tx)
	);

	assign led=sw;

endmodule
