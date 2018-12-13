`timescale 1ns / 1ps

module karplus_strong_tb;

	reg clk;
	reg rst;
	reg start;
	reg newnote;
	reg[10:0] length;

	wire signed[23:0] dout;
	wire dout_valid;

	karplus_strong uut(
		.clk(clk),
		.rst(rst),
		.start(start),
		.newnote(newnote),
		.length(length),
		.dout(dout),
		.dout_valid(dout_valid)
	);

	task pulse_start(input[31:0] len, input new_note);
		integer i;
		begin
			@(posedge clk) ;
			start=1;
			newnote=new_note;
			@(posedge clk) ;
			start=0;
			newnote=0;
			@(negedge dout_valid) ;
			for(i=0;i<len-1;i=i+1) begin
				@(posedge clk) ;
				start=1;
				@(posedge clk) ;
				start=0;
				#100;
			end
		end
	endtask

	integer file;

	initial begin
		file=$fopen("sim_out.txt");
		clk=0;
		rst=1;
		start=0;
		newnote=0;
		#100;
		rst=0;
		#1000;
		length=183;
		pulse_start(24000,0);
		#1000;
		length=145;
		pulse_start(24000,1);
		#1000;
		length=183;
		pulse_start(24000,1);
		#1000;
		length=145;
		pulse_start(24000,1);
		#1000;
		length=122;
		pulse_start(48000,1);
		#1000;
		length=122;
		pulse_start(48000,1);
		#1000;
		$fclose(file);
		$finish();
	end

	always #5 clk<=~clk;

	always@(posedge dout_valid) $fdisplay(file,"%d",dout);

endmodule
