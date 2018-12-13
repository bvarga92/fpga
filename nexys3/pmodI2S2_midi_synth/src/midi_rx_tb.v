`timescale 1ns / 1ps

module midi_rx_tb;

	reg clk;
	reg rst;
	reg rx;

	wire rx_byte_valid;
	wire[7:0] rx_byte;

	midi_rx uut(
		.clk(clk),
		.rst(rst),
		.rx(rx), 
		.rx_byte(rx_byte), 
		.rx_byte_valid(rx_byte_valid)
	);

	task midi_tx(input[7:0] data);
		integer i, j;
		begin
			@(posedge clk) ;
			rx=0;
			for(j=0; j<3200; j=j+1) @(posedge clk) ;
			for(i=0; i<8; i=i+1)
			begin
				rx=data[i];
				for(j=0; j<3200; j=j+1) @(posedge clk) ;			
			end
			rx=1;
			for(j=0; j<3200; j=j+1) @(posedge clk) ;		
		end
	endtask

	initial begin
		clk=0;
		rst=1;
		rx=1;
		#100;
		rst=0;
		#1000;
		midi_tx(8'h55);
		#1_000_000;
		midi_tx(8'h12);
		#1_000_000;
		midi_tx(8'hFA);
	end

	always #5 clk<=~clk;

endmodule
