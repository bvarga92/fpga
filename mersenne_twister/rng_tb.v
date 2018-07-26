`timescale 1ns / 1ps

module rng_tb;

	reg clk;
	reg rst;
	reg start;
	wire valid;
	wire[31:0] rand_out;

	rng #(
		.SEED(5489)
	) uut(
		.clk(clk),
		.rst(rst),
		.start(start),
		.valid(valid),
		.rand_out(rand_out)
	);

	integer i;

	initial begin
		clk=0;
		rst=1;
		start=0;
		#101;
		rst=0;
		@(posedge uut.init_done) ;
		$display("Inicializalas kesz. Az MT tomb tartalma:");
		uut.print_mt;
		$display("\nAz elso 1000 kimenet:");
		for(i=0;i<1000;i=i+1) begin
			@(posedge valid) ;
			$display("%d",rand_out);
			#101;
			@(negedge clk) ;
			start=1;
			@(negedge clk) ;
			start=0;
		end
		$finish;
	end

	always #5 clk<=~clk;

endmodule
