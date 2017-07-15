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
	input[4:0] btns_5bits_tri_i,
	output[7:0] leds_8bits_tri_o,
	input[7:0] sws_8bits_tri_i,
	output[1:0] cam_rst_pwdn_tri_o,
	inout cam_i2c_scl_io,
	inout cam_i2c_sda_io,
	output cam_xclk,
	input cam_pclk,
	input cam_vsync,
	input cam_href,
	input[7:0] cam_data,
	output vga_hsync,
	output vga_vsync,
	output[11:0] vga_rgb
);

	wire cam_i2c_scl_i;
	wire cam_i2c_scl_o;
	wire cam_i2c_scl_t;
	wire cam_i2c_sda_i;
	wire cam_i2c_sda_o;
	wire cam_i2c_sda_t;

	IOBUF cam_i2c_scl_iobuf(
		.I(cam_i2c_scl_o),
		.IO(cam_i2c_scl_io),
		.O(cam_i2c_scl_i),
		.T(cam_i2c_scl_t)
	);

	IOBUF cam_i2c_sda_iobuf(
		.I(cam_i2c_sda_o),
		.IO(cam_i2c_sda_io),
		.O(cam_i2c_sda_i),
		.T(cam_i2c_sda_t)
	);

	wire CLK, RSTN, fb_wr_en;
	wire[18:0] fb_rd_addr, fb_wr_addr;
	wire[11:0] fb_rd_data, fb_wr_data;

	cpu_sys cpu_sys_i(
		.CLK(CLK),
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
		.FB_PORTA_addr(fb_wr_addr),
		.FB_PORTA_clk(CLK),
		.FB_PORTA_din(fb_wr_data),
		.FB_PORTA_we(fb_wr_en),
		.FB_PORTB_addr(fb_rd_addr),
		.FB_PORTB_clk(CLK),
		.FB_PORTB_dout(fb_rd_data),
		.FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
		.FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
		.FIXED_IO_mio(FIXED_IO_mio),
		.FIXED_IO_ps_clk(FIXED_IO_ps_clk),
		.FIXED_IO_ps_porb(FIXED_IO_ps_porb),
		.FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
		.RSTN(RSTN),
		.btns_5bits_tri_i(btns_5bits_tri_i),
		.cam_i2c_scl_i(cam_i2c_scl_i),
		.cam_i2c_scl_o(cam_i2c_scl_o),
		.cam_i2c_scl_t(cam_i2c_scl_t),
		.cam_i2c_sda_i(cam_i2c_sda_i),
		.cam_i2c_sda_o(cam_i2c_sda_o),
		.cam_i2c_sda_t(cam_i2c_sda_t),
		.cam_rst_pwdn_tri_o(cam_rst_pwdn_tri_o),
		.cam_xclk(cam_xclk),
		.leds_8bits_tri_o(leds_8bits_tri_o),
		.sws_8bits_tri_i(sws_8bits_tri_i)
	);

	wire[8:0] cam_row;
	wire[9:0] cam_col;
	wire[14:0] cam_rgb;

	cam_capture cam_capture_i(
		.clk(CLK),
		.rst(~RSTN),
		.pclk(cam_pclk),
		.vsync(cam_vsync),
		.href(cam_href),
		.data(cam_data),
		.row(cam_row),
		.col(cam_col),
		.rgb555(cam_rgb),
		.valid(fb_wr_en)
	);

	assign fb_wr_addr={cam_row,9'd0}+{cam_row,7'd0}+cam_col;
	assign fb_wr_data={cam_rgb[14:11],cam_rgb[9:6],cam_rgb[4:1]};

	wire[9:0] vga_row;
	wire[9:0] vga_col;
	wire[11:0] vga_fb_data;

	vga vga_i(
		.clk(CLK),
		.rst(~RSTN),
		.row(vga_row),
		.col(vga_col),
		.fb_data(vga_fb_data),
		.hsync(vga_hsync),
		.vsync(vga_vsync),
		.rgb(vga_rgb)
	);

	wire fb_en=(vga_row>59)&(vga_row<540)&(vga_col>79)&(vga_col<720);
	wire[9:0] fb_row=vga_row-60;
	assign fb_rd_addr={fb_row,9'd0}+{fb_row,7'd0}+vga_col-79;
	assign vga_fb_data=fb_en?fb_rd_data:12'b1111_1111_1111;

endmodule
