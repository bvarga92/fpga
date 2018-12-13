/********************************************************************/
/*                                                                  */
/* Orajel csokkentese ket fokozatban: (128/125)*(24/25)=0.98304     */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module clk_gen(
	input  clk_in,
	output clk_out
);

`ifndef XILINX_ISIM

	wire clk_in_bufg;
	wire dcm0_clkfx;
	wire dcm0_clkfx_bufg;

	IBUFG ibufg_in(
		.O(clk_in_bufg),
		.I(clk_in)
	);

	DCM_CLKGEN #(
		.CLKFXDV_DIVIDE(2),
		.CLKFX_DIVIDE(125),
		.CLKFX_MD_MAX(0.0),
		.CLKFX_MULTIPLY(128),
		.CLKIN_PERIOD(10.0),
		.SPREAD_SPECTRUM("NONE"),
		.STARTUP_WAIT("FALSE")
	)
	DCM_CLKGEN_0(
		.CLKFX(dcm0_clkfx),
		.CLKFX180(),
		.CLKFXDV(),
		.LOCKED(),
		.PROGDONE(),
		.STATUS(),
		.CLKIN(clk_in_bufg),
		.FREEZEDCM(1'b0),
		.PROGCLK(1'b0),
		.PROGDATA(1'b0),
		.PROGEN(1'b0),
		.RST(1'b0)
	);

	BUFG bufg_dcm0_clkfx(
		.O(dcm0_clkfx_bufg),
		.I(dcm0_clkfx)
	);

	wire dcm1_clkfx;
	wire dcm1_clkfx_bufg;
	wire dcm1_locked;

	DCM_CLKGEN #(
		.CLKFXDV_DIVIDE(2),
		.CLKFX_DIVIDE(25),
		.CLKFX_MD_MAX(0.0),
		.CLKFX_MULTIPLY(24),
		.CLKIN_PERIOD(9.765625),
		.SPREAD_SPECTRUM("NONE"),
		.STARTUP_WAIT("FALSE")
	)
	DCM_CLKGEN_1(
		.CLKFX(dcm1_clkfx),
		.CLKFX180(),
		.CLKFXDV(),
		.LOCKED(dcm1_locked),
		.PROGDONE(),
		.STATUS(),
		.CLKIN(dcm0_clkfx_bufg),
		.FREEZEDCM(1'b0),
		.PROGCLK(1'b0),
		.PROGDATA(1'b0),
		.PROGEN(1'b0),
		.RST(1'b0)
	);

	BUFGMUX bufg_dcm1_clkfx(
		.O(dcm1_clkfx_bufg),
		.I0(1'b0),
		.I1(dcm1_clkfx),
		.S(dcm1_locked)
	);

	assign clk_out=dcm1_clkfx_bufg;

`else

	assign clk_out=clk_in;

`endif

endmodule
