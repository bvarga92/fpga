`timescale 1ns / 1ps

module midi_note_fifo_tb;

	reg clk;
	reg rst;
	reg [7:0] rx_byte;
	reg rx_byte_valid;
	reg rd;

	wire[7:0] key;
	wire[7:0] velocity;
	wire empty;
	wire full;

	midi_note_fifo uut(
		.clk(clk), 
		.rst(rst), 
		.rx_byte(rx_byte), 
		.rx_byte_valid(rx_byte_valid),
		.rd(rd),
		.key(key),
		.velocity(velocity),
		.empty(empty),
		.full(full)
	);

	initial begin
		clk=0;
		rst=1;
		rx_byte=0;
		rx_byte_valid=0;
		rd=0;
		#100;
		rst=0;
		#1000;
		@(posedge clk) ;
		rx_byte=8'h90;
		rx_byte_valid=1;
		@(posedge clk) ;
		rx_byte_valid=0;
		#100;
		@(posedge clk) ;
		rx_byte=8'h45;
		rx_byte_valid=1;
		@(posedge clk) ;
		rx_byte_valid=0;
		#100;
		@(posedge clk) ;
		rx_byte=8'h55;
		rx_byte_valid=1;
		@(posedge clk) ;
		rx_byte_valid=0;
		#1000;
		@(posedge clk) ;
		rx_byte=8'h90;
		rx_byte_valid=1;
		@(posedge clk) ;
		rx_byte_valid=0;
		#100;
		@(posedge clk) ;
		rx_byte=8'h30;
		rx_byte_valid=1;
		@(posedge clk) ;
		rx_byte_valid=0;
		#100;
		@(posedge clk) ;
		rx_byte=8'hFD;
		rx_byte_valid=1;
		@(posedge clk) ;
		rx_byte_valid=0;
		#1000;
		@(posedge clk) ;
		rd=1;
		@(posedge clk) ;
		rd=0;
		#1000;
		@(posedge clk) ;
		rd=1;
		@(posedge clk) ;
		rd=0;
		#1000;
		@(posedge clk) ;
		rd=1;
		@(posedge clk) ;
		rd=0;
	end

	always #5 clk<=~clk;

endmodule
