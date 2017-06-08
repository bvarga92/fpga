`timescale 1 ps / 1 ps

module toplevel(
	inout[14:0] DDR_addr,
	inout[2:0] DDR_ba,
	inout DDR_cas_n,
	inout DDR_ck_n,
	inout DDR_ck_p,
	inout DDR_cke,
	inout DDR_cs_n,
	inout[3:0] DDR_dm,
	inout[31:0] DDR_dq,
	inout[3:0] DDR_dqs_n,
	inout[3:0] DDR_dqs_p,
	inout DDR_odt,
	inout DDR_ras_n,
	inout DDR_reset_n,
	inout DDR_we_n,
	inout FIXED_IO_ddr_vrn,
	inout FIXED_IO_ddr_vrp,
	inout[53:0] FIXED_IO_mio,
	inout FIXED_IO_ps_clk,
	inout FIXED_IO_ps_porb,
	inout FIXED_IO_ps_srstb,
	output[1:0] ac_addr,
	inout ac_i2c_scl_io,
	inout ac_i2c_sda_io,
	output ac_i2s_mclk,
	input ac_i2s_lrck,
	input ac_i2s_bclk,
	input ac_i2s_adc,
	output ac_i2s_dac,
	input[4:0] btns_5bits_tri_i,
	output[7:0] leds_8bits_tri_o,
	input[7:0] sws_8bits_tri_i
);

	wire AMSCK;
	wire[14:0] DDR_addr;
	wire[2:0] DDR_ba;
	wire DDR_cas_n;
	wire DDR_ck_n;
	wire DDR_ck_p;
	wire DDR_cke;
	wire DDR_cs_n;
	wire[3:0] DDR_dm;
	wire[31:0] DDR_dq;
	wire[3:0] DDR_dqs_n;
	wire[3:0] DDR_dqs_p;
	wire DDR_odt;
	wire DDR_ras_n;
	wire DDR_reset_n;
	wire DDR_we_n;
	wire FIFO_READ_L_empty;
	wire[23:0] FIFO_READ_L_rd_data;
	wire FIFO_READ_L_rd_en;
	wire FIFO_READ_R_empty;
	wire[23:0] FIFO_READ_R_rd_data;
	wire FIFO_READ_R_rd_en;
	wire FIFO_WRITE_L_full;
	wire[23:0] FIFO_WRITE_L_wr_data;
	wire FIFO_WRITE_L_wr_en;
	wire FIFO_WRITE_R_full;
	wire[23:0] FIFO_WRITE_R_wr_data;
	wire FIFO_WRITE_R_wr_en;
	wire FIXED_IO_ddr_vrn;
	wire FIXED_IO_ddr_vrp;
	wire[53:0] FIXED_IO_mio;
	wire FIXED_IO_ps_clk;
	wire FIXED_IO_ps_porb;
	wire FIXED_IO_ps_srstb;
	wire[1:0] ac_addr;
	wire ac_i2c_scl_i;
	wire ac_i2c_scl_io;
	wire ac_i2c_scl_o;
	wire ac_i2c_scl_t;
	wire ac_i2c_sda_i;
	wire ac_i2c_sda_io;
	wire ac_i2c_sda_o;
	wire ac_i2c_sda_t;
	wire[4:0] btns_5bits_tri_i;
	wire[7:0] leds_8bits_tri_o;
	wire[7:0] sws_8bits_tri_i;

	IOBUF ac_i2c_scl_iobuf(
		.I(ac_i2c_scl_o),
		.IO(ac_i2c_scl_io),
		.O(ac_i2c_scl_i),
		.T(ac_i2c_scl_t)
	);

	IOBUF ac_i2c_sda_iobuf(
		.I(ac_i2c_sda_o),
		.IO(ac_i2c_sda_io),
		.O(ac_i2c_sda_i),
		.T(ac_i2c_sda_t)
	);

	cpu_sys cpu_sys_i(
		.AMSCK(AMSCK),
		.DDR_addr(DDR_addr),
		.DDR_ba(DDR_ba),
		.DDR_cas_n(DDR_cas_n),
		.DDR_ck_n(DDR_ck_n),
		.DDR_ck_p(DDR_ck_p),
		.DDR_cke(DDR_cke),
		.DDR_cs_n(DDR_cs_n),
		.DDR_dm(DDR_dm),
		.DDR_dq(DDR_dq),
		.DDR_dqs_n(DDR_dqs_n),
		.DDR_dqs_p(DDR_dqs_p),
		.DDR_odt(DDR_odt),
		.DDR_ras_n(DDR_ras_n),
		.DDR_reset_n(DDR_reset_n),
		.DDR_we_n(DDR_we_n),
		.FIFO_READ_L_empty(FIFO_READ_L_empty),
		.FIFO_READ_L_rd_data(FIFO_READ_L_rd_data),
		.FIFO_READ_L_rd_en(FIFO_READ_L_rd_en),
		.FIFO_READ_R_empty(FIFO_READ_R_empty),
		.FIFO_READ_R_rd_data(FIFO_READ_R_rd_data),
		.FIFO_READ_R_rd_en(FIFO_READ_R_rd_en),
		.FIFO_WRITE_L_full(FIFO_WRITE_L_full),
		.FIFO_WRITE_L_wr_data(FIFO_WRITE_L_wr_data),
		.FIFO_WRITE_L_wr_en(FIFO_WRITE_L_wr_en),
		.FIFO_WRITE_R_full(FIFO_WRITE_R_full),
		.FIFO_WRITE_R_wr_data(FIFO_WRITE_R_wr_data),
		.FIFO_WRITE_R_wr_en(FIFO_WRITE_R_wr_en),
		.FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
		.FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
		.FIXED_IO_mio(FIXED_IO_mio),
		.FIXED_IO_ps_clk(FIXED_IO_ps_clk),
		.FIXED_IO_ps_porb(FIXED_IO_ps_porb),
		.FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
		.ac_addr(ac_addr),
		.ac_i2c_scl_i(ac_i2c_scl_i),
		.ac_i2c_scl_o(ac_i2c_scl_o),
		.ac_i2c_scl_t(ac_i2c_scl_t),
		.ac_i2c_sda_i(ac_i2c_sda_i),
		.ac_i2c_sda_o(ac_i2c_sda_o),
		.ac_i2c_sda_t(ac_i2c_sda_t),
		.btns_5bits_tri_i(btns_5bits_tri_i),
		.leds_8bits_tri_o(leds_8bits_tri_o),
		.sws_8bits_tri_i(sws_8bits_tri_i)
	);

	wire[23:0] ac_dout;
	reg[23:0] ac_din;
	wire ac_rd_l;
	wire ac_rd_r;
	wire ac_valid_l;
	wire ac_valid_r;

	i2s i2s_i(
		.AMSCK(AMSCK),
		.lrck(ac_i2s_lrck),
		.bclk(ac_i2s_bclk),
		.sdin(ac_i2s_adc),
		.sdout(ac_i2s_dac),
		.mclk(ac_i2s_mclk),
		.din(ac_din),
		.rd_l(ac_rd_l),
		.rd_r(ac_rd_r),
		.dout(ac_dout),
		.valid_l(ac_valid_l),
		.valid_r(ac_valid_r)
	);

	assign FIFO_WRITE_L_wr_data=ac_dout;
	assign FIFO_WRITE_L_wr_en=ac_valid_l;
	assign FIFO_WRITE_R_wr_data=ac_dout;
	assign FIFO_WRITE_R_wr_en=ac_valid_r;
	assign FIFO_READ_L_rd_en=ac_rd_l;
	assign FIFO_READ_R_rd_en=ac_rd_r;

	reg ac_rd_l_dl, ac_rd_r_dl;
	always@(posedge AMSCK) ac_rd_l_dl<=ac_rd_l;
	always@(posedge AMSCK) ac_rd_r_dl<=ac_rd_r;
	always@(posedge AMSCK)
		if(ac_rd_l_dl)
			ac_din<=FIFO_READ_L_rd_data;
		else if(ac_rd_r_dl)
			ac_din<=FIFO_READ_R_rd_data;

endmodule
