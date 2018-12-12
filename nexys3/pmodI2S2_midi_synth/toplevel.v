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
	input  adc_sdata,
	input midi_in,
	output[7:0] led
);

	wire clk, mclk, lrck, sclk, dac_rd_adc_wr, midi_rx_byte_valid, empty;
	wire[7:0] midi_rx_byte, key, velocity;
	wire[10:0] length;
	wire[23:0] sound_out;
	reg empty_dl, newnote, note_off;
	reg[1:0] dac_rd_adc_wr_dl;
	reg[7:0] key_reg;

	clk_gen clk_gen_i(
		.clk_in(clk100),
		.clk_out(clk)
	);

	midi_rx midi_rx_i(
		.clk(clk),
		.rst(rst),
		.rx(midi_in),
		.rx_byte(midi_rx_byte),
		.rx_byte_valid(midi_rx_byte_valid)
	);

	midi_note_fifo midi_note_fifo_i(
		.clk(clk),
		.rst(rst),
		.rx_byte(midi_rx_byte),
		.rx_byte_valid(midi_rx_byte_valid),
		.rd(dac_rd_adc_wr),
		.key(key),
		.velocity(velocity),
		.empty(empty),
		.full()
	);

	always@(posedge clk)
	begin
		dac_rd_adc_wr_dl<={dac_rd_adc_wr_dl[0], dac_rd_adc_wr};
		empty_dl<=empty;
	end

	always@(posedge clk)
		if(rst) begin
			newnote<=0;
			note_off<=1;
		end
		else if(dac_rd_adc_wr_dl[0] & ~empty_dl) begin
			if(velocity==0) begin
				note_off<=(key==key_reg);
				newnote<=0;
			end
			else begin
				note_off<=0;
				newnote<=1;
				key_reg<=key;
			end
		end
		else
			newnote<=0;

	key_to_length key_to_length_i(
		.key(key_reg),
		.length(length)
	);

	karplus_strong karplus_strong_i(
		.clk(clk),
		.rst(rst),
		.start(dac_rd_adc_wr_dl[1]),
		.newnote(newnote),
		.length(length),
		.dout(sound_out),
		.dout_valid()
	 );

	pmodi2s2 pmodi2s2_i(
		.clk(clk),
		.rst(rst),
		.mclk(mclk),
		.lrck(lrck),
		.sclk(sclk),
		.dac_l(note_off?0:sound_out),
		.dac_r(note_off?0:sound_out),
		.dac_sdata(dac_sdata),
		.adc_sdata(adc_sdata),
		.adc_l(),
		.adc_r(),
		.dac_rd_adc_wr(dac_rd_adc_wr)
	);

	assign adc_mclk=mclk;
	assign dac_mclk=mclk;
	assign adc_sclk=sclk;
	assign dac_sclk=sclk;
	assign adc_lrck=lrck;
	assign dac_lrck=lrck;

	assign led=key;

endmodule
