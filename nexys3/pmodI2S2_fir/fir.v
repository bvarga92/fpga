`timescale 1ns / 1ps

module fir(
	input clk,
	input rst,
	input[23:0] din,
	input din_valid,
	output reg[23:0] dout,
	output reg dout_valid
);

	reg[7:0] coeff_addr;

	/* allapotregiszter (1, ha konvolucio van folyamatban) */
	reg state;
	always@(posedge clk)
		if(rst)
			state<=0;
		else if(din_valid)
			state<=1;
		else if(coeff_addr==255)
			state<=0;

	/* egyutthato cimszamlalo (0...255) */
	always@(posedge clk)
		if(din_valid)
			coeff_addr<=0;
		else if(state)
			coeff_addr<=coeff_addr+1;

	/* allapotregiszter kesleltetve */
	reg[7:0] state_dl;
	always@(posedge clk)
		state_dl<={state_dl[6:0], state};

	/* minta irasi cimszamlalo */
	reg[7:0] smpl_wr_addr;
	always@(posedge clk)
		if(rst)
			smpl_wr_addr<=0;
		else if(din_valid)
			smpl_wr_addr<=smpl_wr_addr+1;

	/* minta olvasasi cimszamlalo */
	reg[7:0] smpl_rd_addr;
	always@(posedge clk)
		if(din_valid)
			smpl_rd_addr<=smpl_wr_addr;
		else
			smpl_rd_addr<= smpl_rd_addr-1;

	/* RAM a jel mintainak (formatum: s.23) */
	wire[35:0] smpl_ram_dout;
	ram_256x36 smpl_ram(
		.clk_a(clk),
		.we_a(din_valid),
		.addr_a(smpl_wr_addr),
		.din_a({{12{din[23]}}, din}),
		.dout_a(),
		.clk_b(clk),
		.we_b(1'b0),
		.addr_b(smpl_rd_addr),
		.din_b(36'b0),
		.dout_b(smpl_ram_dout)
	);

	/* ROM a szuroegyutthatoknak (formatum: s.3.31) */
	wire[34:0] coeff_rom_dout;
	rom_256x35 coeff_rom(
		.clk(clk),
		.addr(coeff_addr),
		.dout(coeff_rom_dout)
	);

	/* szorzas: s.23 * s.3.31 = s.4.54 */
	wire signed[69:0] mul_res;
	mul_35x35 mul(
		.clk(clk),
		.a(smpl_ram_dout[34:0]),
		.b(coeff_rom_dout),
		.m(mul_res)
	);

	/* 256 db s.4.54 osszege: s.12.54 */
	reg signed[66:0] accu;
	always@(posedge clk)
		if (din_valid)
			accu<=67'b0;
		else if(state_dl[6])
			accu<=accu+mul_res[66:0];

	/* kimenet eloallitasa */
	always@(posedge clk)
	begin
		if(state_dl[7:6]==2'b10)
			if(accu[66]==0 & accu[65:54]!=0)
				dout<=24'h7fffff; //pozitiv szaturacio (0.99999)
			else if(accu[66]==1 & accu[65:54]!=12'hFFF)
				dout<=24'h800000; //negativ szaturacio (-1)
			else
				dout<=accu[54:31]; //csonkolas
		dout_valid<=(state_dl[7:6]==2'b10);
	end

endmodule
