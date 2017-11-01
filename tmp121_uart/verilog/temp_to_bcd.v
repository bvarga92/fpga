`timescale 1ns / 1ps

module temp_to_bcd(
	input clk,
	input rst,
	input[12:0] temp,
	input[7:0] sw, //sw[7]-tol fuggoen sw[6:0] vagy megjelenitodik, vagy kivonodik a homersekletbol
	output reg[3:0] d3, //elojel
	output[3:0] d2, //MSD
	output[3:0] d1, //LSD
	output reg[3:0] d0 //tortresz
);

	reg[7:0] data_in, data_out, data_old, data_conv; 
	reg[3:0] data_high; 		

	/* iterativ BCD konverzio */
	always@(posedge clk)
		if(~(data_in==data_old)|rst)
		begin
			data_old<=data_in;
			data_conv<=data_in;
			data_high<=0;
			if(rst) data_out<=0;
		end
		else if(data_conv>9)
		begin
			data_conv<=data_conv-10;
			data_high<=data_high+1;
		end
		else
			data_out<={data_high,data_conv[3:0]};

	assign d1=data_out[3:0];
	assign d2=data_out[7:4];

	/* a beallitott ertek kivonasa es abszolutertek-kepzes */
	wire[12:0] temp_off=temp-{2'b00,sw[6:0],4'b0000};
	wire[11:0] temp_abs=temp_off[12]?(-temp_off):temp_off;

	//tortresz
	wire[6:0] frac_mult={temp_abs[3:0],2'b00}+temp_abs[3:0]; //temp_abs*5
	wire[3:0] frac=frac_mult[6:3]; //osztas 8-cal

	//adatvalasztas a kovetkezo ciklusra
	always@(posedge clk)
		if(rst)
		begin
			data_in<=0;
			d3<=0;
			d0<=0;
		end
		else
		begin
			data_in<=sw[7]?temp_abs[11:4]:{1'b0,sw[6:0]};
			d3<=(sw[7]&temp_off[12])?10:15;
			d0<=sw[7]?frac:15;
		end

endmodule
