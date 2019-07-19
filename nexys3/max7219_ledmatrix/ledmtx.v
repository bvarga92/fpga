`timescale 1ns / 1ps

module ledmtx #(
	parameter NUM_IMAGES=1
)(
	input clk,
	input rst,
	input start,
	input[15:0] ram_offset,
	output max7219_din,
	output max7219_cs,
	output max7219_sclk,
	output reg busy
);

	parameter CNTR_MAX=5999;
	parameter NUM_REGISTERS=13;
	parameter DATABITS=256;

	/* LED driver modul */
	wire max7219_start, max7219_busy;
	reg[DATABITS-1:0] data;
	max7219 #(
		.CS_FALL_TO_FIRST_SCLK_RISE(50),
		.LAST_SCLK_FALL_TO_CS_RISE(50),
		.CLK_PER_SCLK(20),
		.DATABITS(DATABITS)
	) max7219_i(
		.clk(clk),
		.rst(rst),
		.start(max7219_start),
		.data(data),
		.cs(max7219_cs),
		.sclk(max7219_sclk),
		.dout(max7219_din),
		.busy(max7219_busy)
	);

	/* statuszregiszter es regiszterszamlalo */
	reg[$clog2(NUM_REGISTERS+1)-1:0] regcntr;
	always@(posedge clk)
		if(rst | ~busy)
			regcntr<=0;
		else if(max7219_start & regcntr<NUM_REGISTERS)
			regcntr<=regcntr+1;

	always@(posedge clk)
		if(rst | (regcntr==NUM_REGISTERS & ~max7219_busy))
			busy<=0;
		else if(start)
			busy<=1;

	/* szamlalo az utemezeshez */
	reg[$clog2(CNTR_MAX+1)-1:0] cntr;
	always@(posedge clk)
		if(rst | (start & ~busy) | cntr==CNTR_MAX)
			cntr<=0;
		else if(busy)
			cntr<=cntr+1;
	assign max7219_start=(cntr==CNTR_MAX & regcntr<NUM_REGISTERS);

	/* blokk RAM a beirando regiszterertekeknek */
	reg[$clog2(NUM_REGISTERS)-1:0] addr;
	always@(posedge clk)
		if(rst | (start & ~busy))
			addr<=-1;
		else if(cntr==CNTR_MAX-2)
			addr<=addr+1;

	reg[15:0] ram_offset_lat;
	always@(posedge clk)
		if(start & ~busy)
			ram_offset_lat<=ram_offset;

	(* RAM_EXTRACT="yes", RAM_STYLE="block" *)reg[DATABITS-1:0] mem[NUM_REGISTERS*NUM_IMAGES-1:0];
	initial $readmemh("./src/ram_init.txt",mem);
	always@(posedge clk)
		data<=mem[addr+ram_offset_lat];

endmodule
