`timescale 1 ps / 1 ps

module cam_capture(
	input clk,
	input rst,
	input pclk,
	input vsync,
	input href,
	input[7:0] data,
	output reg[8:0] row,
	output reg[9:0] col,
	output reg[14:0] rgb555,
	output reg valid
);

	/* elek detektalasa */
	reg[1:0] pclk_shr;
	reg[1:0] href_shr;
	always@(posedge clk) pclk_shr<=rst?2'b00:{pclk_shr[0],pclk};
	always@(posedge clk) href_shr<=rst?2'b00:{href_shr[0],href};
	wire pclk_rise=(pclk_shr==2'b01);
	wire pclk_fall=(pclk_shr==2'b10);
	wire href_rise=(href_shr==2'b01);
	wire href_fall=(href_shr==2'b10);

	/* sorszamlalo */
	reg[8:0] row_cntr;
	always@(posedge clk)
		if(rst|vsync)
			row_cntr<=0;
		else if(href_fall)
			row_cntr<=row_cntr+1;

	/* soronkenti bajtszamlalo */
	reg[10:0] byte_cntr;
	always@(posedge clk)
		if(rst|href_rise)
			byte_cntr<=0;
		else if((href==1'b1)&pclk_fall)
			byte_cntr<=byte_cntr+1;

	/* adat latch-elese */
	reg[6:0] data_lat;
	always@(posedge clk)
		if(rst)
		begin
			data_lat<=0;
			rgb555<=0;
		end
		else if((href==1'b1)&pclk_rise)
		begin
			if(~byte_cntr[0])
				data_lat<=data[6:0];
			else
				rgb555<={data_lat,data};
		end

	/* frame buffer beiro jel es cim */
	always@(posedge clk)
		if(rst)
		begin
			valid<=0;
			row<=0;
			col<=0;
		end
		else if((href==1'b1)&pclk_rise&byte_cntr[0])
		begin
			valid<=1;
			row<=row_cntr;
			col<=byte_cntr[10:1];
		end
		else
			valid<=0;

endmodule
