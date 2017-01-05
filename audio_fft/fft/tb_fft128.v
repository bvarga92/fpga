/********************************************************************/
/*                                                                  */
/* Testbench a 128 pontos FFT modulhoz.                             */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module tb_fft128;

	reg clk, rst, start, ramsel;
	wire busy;
	reg we_a, we_b;
	wire ram_we_a, fft_we_a, ram_we_b, fft_we_b;
	reg[6:0] addr_a, addr_b, a;
	wire[6:0] ram_addr_a, fft_addr_a, ram_addr_b, fft_addr_b, a_rev;
	reg[25:0] din_a, din_b;
	wire[25:0] ram_din_a, fft_din_a, ram_din_b, fft_din_b;
	wire [25:0] dout_a, dout_b;

	/* mintatar */
	ram128x26 sample_ram(
		.clk_a(clk),
		.we_a(ram_we_a),
		.en_a(1'b1),
		.clk_b(clk),
		.we_b(ram_we_b),
		.en_b(1'b1),
		.addr_a(ram_addr_a),
		.addr_b(ram_addr_b),
		.din_a(ram_din_a),
		.din_b(ram_din_b),
		.dout_a(dout_a),
		.dout_b(dout_b)
	);

	/* FFT egyseg */
	fft128 fft(
		.clk(clk),
		.rst(rst),
		.ram_we_a(fft_we_a),
		.ram_we_b(fft_we_b),
		.ram_addr_a(fft_addr_a),
		.ram_addr_b(fft_addr_b),
		.ram_din_a(fft_din_a),
		.ram_din_b(fft_din_b),
		.ram_dout_a(dout_a),
		.ram_dout_b(dout_b),
		.start(start),
		.busy(busy)
	);

	/* bitsorrend-fordito */
	bitreverse bitreverse_i(a,a_rev);

	/* multiplexer a memoria bemeno jeleihez */
	assign ram_we_a=ramsel?we_a:fft_we_a;
	assign ram_we_b=ramsel?we_b:fft_we_b;
	assign ram_addr_a=ramsel?addr_a:fft_addr_a;
	assign ram_addr_b=ramsel?addr_b:fft_addr_b;
	assign ram_din_a=ramsel?din_a:fft_din_a;
	assign ram_din_b=ramsel?din_b:fft_din_b;
	
	integer i;
	initial begin
		clk=0;
		rst=1;
		start=0;
		ramsel=0;
		we_a=0;
		we_b=0;
		#100;
		rst=0;
		#6
		/* [1 1 ... 1]  -->  [1 0 ... 0] */
		for(i=0;i<128;i=i+1)
		begin
			a=i;
			din_a={13'd0,13'b0111111111111};
			#10;
			addr_a=a_rev;
			ramsel=1;
			we_a=1;
		end
		#10;
		we_a=0;
		ramsel=0;
		#20;
		start=1;
		#10;
		start=0;
		#25000;
		ramsel=1;
		for(i=0;i<64;i=i+1)
		begin
			addr_a=i;
			#10;
		end
		ramsel=0;
		#100;
		/* [-1 -1 1 1 -1 -1 1 1 ...]  -->  32. es 96. elem 0.707, a tobbi 0 */
		for(i=0;i<128;i=i+1)
		begin
			a=i;
			din_a=(i&2)?{13'd0,13'b0111111111111}:{13'd0,13'b1000000000000};
			#10;
			addr_a=a_rev;
			ramsel=1;
			we_a=1;
		end
		#10;
		we_a=0;
		ramsel=0;
		#20;
		start=1;
		#10;
		start=0;
		#25000;
		ramsel=1;
		for(i=0;i<64;i=i+1)
		begin
			addr_a=i;
			#10;
		end
		ramsel=0;
		#100;
		/* [1 1 ... 1 1 -1 -1 ... -1 -1]  -->  minden masodik 0, 1/n rendben csokken */
		for(i=0;i<128;i=i+1)
		begin
			a=i;
			din_a=(i<64)?{13'd0,13'b0111111111111}:{13'd0,13'b1000000000000};
			#10;
			addr_a=a_rev;
			ramsel=1;
			we_a=1;
		end
		#10;
		we_a=0;
		ramsel=0;
		#20;
		start=1;
		#10;
		start=0;
		#25000;
		ramsel=1;
		for(i=0;i<64;i=i+1)
		begin
			addr_a=i;
			#10;
		end
		ramsel=0;
	end

always #5 clk<=~clk;

endmodule
