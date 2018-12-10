`timescale 1ns / 1ps

module fir_tb;
	reg clk;
	reg rst;
	reg din_valid;
	wire[23:0] din;
	wire dout_valid;
	wire[23:0] dout;

	fir uut(
		.clk(clk),
		.rst(rst),
		.din(din),
		.din_valid(din_valid),
		.dout(dout),
		.dout_valid(dout_valid)
	);

	initial begin
		clk=1;
		rst=1;
		din_valid=0;
		#102;
		rst=0;
	end

	always #5 clk<=~clk;

	always #3000
	begin
		@(posedge clk)
		#2    din_valid=1;
		#10   din_valid=0;
		#3000 din_valid=1;
		#10   din_valid=0;
	end

	reg[31:0] smpl_cntr=0;
	always@(posedge clk)
		if(din_valid) smpl_cntr<=smpl_cntr+1;

	assign #2 din=(smpl_cntr==3)?'h400000:0; //0.5 magassagu impulzus --> az egyutthatok felet kell visszakapnunk

endmodule
