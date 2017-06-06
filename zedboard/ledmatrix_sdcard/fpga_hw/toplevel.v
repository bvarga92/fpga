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
	output[2:0] ledmtx_rowaddr,
	output ledmtx_clk,
	output ledmtx_oe,
	output ledmtx_lat,
	output ledmtx_r1,
	output ledmtx_g1,
	output ledmtx_b1,
	output ledmtx_r2,
	output ledmtx_g2,
	output ledmtx_b2
);

	wire[31:0] BRAM_PORTB_addr;
	wire BRAM_PORTB_clk;
	wire[31:0] BRAM_PORTB_din;
	wire[31:0] BRAM_PORTB_dout;
	wire BRAM_PORTB_en;
	wire BRAM_PORTB_rst;
	wire[3:0] BRAM_PORTB_we;
	wire CLK;
	wire rstn;
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
	wire FIXED_IO_ddr_vrn;
	wire FIXED_IO_ddr_vrp;
	wire[53:0] FIXED_IO_mio;
	wire FIXED_IO_ps_clk;
	wire FIXED_IO_ps_porb;
	wire FIXED_IO_ps_srstb;
	wire[4:0] btns_5bits_tri_i;
	wire[7:0] leds_8bits_tri_o;
	wire[7:0] sws_8bits_tri_i;

	cpu_subsys cpu_subsys_i(
		.BRAM_PORTB_addr(BRAM_PORTB_addr),
		.BRAM_PORTB_clk(BRAM_PORTB_clk),
		.BRAM_PORTB_din(BRAM_PORTB_din),
		.BRAM_PORTB_dout(BRAM_PORTB_dout),
		.BRAM_PORTB_en(BRAM_PORTB_en),
		.BRAM_PORTB_rst(BRAM_PORTB_rst),
		.BRAM_PORTB_we(BRAM_PORTB_we),
		.CLK(CLK),
		.rstn(rstn),
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
		.FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
		.FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
		.FIXED_IO_mio(FIXED_IO_mio),
		.FIXED_IO_ps_clk(FIXED_IO_ps_clk),
		.FIXED_IO_ps_porb(FIXED_IO_ps_porb),
		.FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
		.btns_5bits_tri_i(btns_5bits_tri_i),
		.leds_8bits_tri_o(leds_8bits_tri_o),
		.sws_8bits_tri_i(sws_8bits_tri_i)
	);

	ledmtx ledmtx_i(
		.clk(CLK),
		.rst(~rstn),
		.enn(1'b0),
		.rowaddr(ledmtx_rowaddr),
		.sclk(ledmtx_clk),
		.oe(ledmtx_oe),
		.lat(ledmtx_lat),
		.r1(ledmtx_r1),
		.g1(ledmtx_g1),
		.b1(ledmtx_b1),
		.r2(ledmtx_r2),
		.g2(ledmtx_g2),
		.b2(ledmtx_b2),
		.ram_addr(BRAM_PORTB_addr[10:2]),
		.ram_data(BRAM_PORTB_dout[23:0]),
		.done()
	);

	assign BRAM_PORTB_clk=CLK;
	assign BRAM_PORTB_rst=~rstn;
	assign BRAM_PORTB_en=1'b1;
	assign BRAM_PORTB_we=4'b0000;
	assign BRAM_PORTB_din=32'd0;

endmodule
