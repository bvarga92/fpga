`timescale 1ns / 1ps

module midi_note_fifo(
	input clk,
	input rst,
	input[7:0] rx_byte,
	input rx_byte_valid,
	input rd,
	output reg[7:0] key,
	output reg[7:0] velocity,
	output empty,
	output full
);

	reg[1:2] cntr;
	always@(posedge clk)
		if(rst)
			cntr<=0;
		else if(rx_byte_valid)
			cntr<=(cntr==2)?0:(cntr+1);

	reg[15:0] shr;
	always@(posedge clk)
		if(rst)
			shr<=0;
		else if(rx_byte_valid)
			shr<={shr[7:0], rx_byte};

	wire[15:0] fifo_dout;
	srl_fifo fifo16(
		.clk(clk),
		.rst(rst),
		.wr(rx_byte_valid & cntr==2 & shr[15:8]==8'h90 & ~full),
		.rd(rd & ~empty),
		.din({shr[7:0], rx_byte}),
		.dout(fifo_dout),
		.empty(empty),
		.full(full)
	);

	always@(posedge clk)
		if(rst)
		begin
			key<=0;
			velocity<=0;
		end
		else if(rd & ~empty)
		begin
			key<=fifo_dout[15:8];
			velocity<=fifo_dout[7:0];
		end

endmodule
