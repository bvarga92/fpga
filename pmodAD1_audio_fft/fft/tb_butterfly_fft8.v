/********************************************************************/
/*                                                                  */
/* Testbench: 8 pontos FFT szekvencialisan vegrehajtott butterfly   */
/* muveletekkel. A kimeneten az amplitudospektrum all elo!          */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module fft8(
		input clk,
		input rst,
		input start, //egy orajelnyi impulzust adjunk ide, ennek hatasara indul a transzformacio
		output busy, //amikor alacsony, akkor ervenyes a kimenet
		input signed [12:0] x0,x1,x2,x3,x4,x5,x6,x7,
		output signed [12:0] o0,o1,o2,o3,o4,o5,o6,o7
	);
	
	reg signed [12:0] twiddle_re, twiddle_im; //aktualis twiddle factor (w)
	reg signed [12:0] buffer_re[0:7], buffer_im[0:7]; //ebben dolgozunk
	wire signed [12:0] bf_in1_re, bf_in1_im, bf_in2_re, bf_in2_im; //butterfly bemenete
	wire signed [12:0] bf_out1_re, bf_out1_im, bf_out2_re, bf_out2_im; //butterfly kimenete
	
	/* butterfly egyseg */
	butterfly butterfly_i(
		.clk(clk),
		.w_re(twiddle_re),
		.w_im(twiddle_im),
		.x1_re(bf_in1_re),
		.x1_im(bf_in1_im),
		.x2_re(bf_in2_re),
		.x2_im(bf_in2_im),
		.y1_re(bf_out1_re),
		.y1_im(bf_out1_im),
		.y2_re(bf_out2_re),
		.y2_im(bf_out2_im)
	);
	
	/* statuszregiszter */
	reg[1:0] status;
	parameter IDLE=2'b00;
	parameter FFTING=2'b01;
	parameter ABSING=2'b11;
	
	/* szamlalok az utemezeshez */
	reg en; //orajelfelezo
	reg[1:0] i; //hanyadik FFT szint
	reg[1:0] j; //szinten belul hanyadik butterfly muvelet
	always@(posedge clk)
		en<=(rst|start)?0:~en;
	always@(posedge clk)
		if(rst)
		begin
			i<=0;
			j<=0;
		end
		else if((status==FFTING)&en)
			if(j==2'd3) //kesz vagyunk a szinttel
			begin
				j<=0;
				if(i==2'd2) //kesz vagyunk a teljes FFT-vel
					i<=0;
				else
					i<=i+1'b1;
			end
			else
				j<=j+1'b1;

	/* aktualis bemenetek cimenek eloallitasa */
	wire[2:0] addr1, addr2;
	assign addr1=({j,1'b0}<<i)|({j,1'b0}>>(3-i));
	assign addr2=({j,1'b1}<<i)|({j,1'b1}>>(3-i));
	assign bf_in1_re=buffer_re[addr1];
	assign bf_in1_im=buffer_im[addr1];
	assign bf_in2_re=buffer_re[addr2];
	assign bf_in2_im=buffer_im[addr2];
	
	/* twiddle factor cimenek eloallitasa */
	wire[1:0] twiddle_addr;
	assign twiddle_addr=j&(4'b1100>>i);
	
	/* twiddle factor lookup table */
	always@(*)
		case(twiddle_addr)
			2'b00: begin //1
			          twiddle_re<=13'b0111111111111;
						 twiddle_im<=13'b0000000000000;
			       end
			2'b01: begin //sqrt(2)/2-j*sqrt(2)/2
			          twiddle_re<=13'b0101101010000;
						 twiddle_im<=13'b1010010101111;
			       end
			2'b10: begin //-j
			          twiddle_re<=13'b0000000000000;
						 twiddle_im<=13'b1000000000000;
			       end
			2'b11: begin //-sqrt(2)/2-j*sqrt(2)/2
			          twiddle_re<=13'b1010010101111;
						 twiddle_im<=13'b1010010101111;
			       end
		endcase

	/* abszolutertek kepzese a kimeneten */
	wire signed [12:0] abs_in1, abs_in2, abs_out;
	abs abs_i(
		.y_re(abs_in1),
		.y_im(abs_in2),
		.y_abs(abs_out)
	);

	/* melyik kimenet abszoluterteket kepezzuk eppen */
	reg[2:0] abscntr;
	always@(posedge clk)
		if(rst|(abscntr==3'd7))
			abscntr<=0;
		else if(status==ABSING)
			abscntr<=abscntr+1'b1;

	assign abs_in1=buffer_re[abscntr];
	assign abs_in2=buffer_im[abscntr];

	/* allapotgep */
	always@(posedge clk)
		if(rst)
			status<=IDLE;
		else if(start) //kaptunk start jelet, elkezdjuk a transzformaciot
			status<=FFTING;
		else if((i==2'd2)&(j==2'd3)&en) //transzformacio kesz, kepezzuk az abszolutertekeket
			status<=ABSING;
		else if(abscntr==3'd7) //abszolutertekek eloalltak
			status<=IDLE;		
	
	assign busy=(status!=IDLE);

	/* buffer irasa: kezdetben a bemenet (bitreverse!), majd a BFU kimenete, vegul abszolutertek */
	reg busy_del;
	reg[2:0] addr1_del, addr2_del;
	always@(posedge clk)
	begin
		busy_del<=busy;
		addr1_del<=addr1;
		addr2_del<=addr2;
	end
	always@(posedge clk)
		if(start)
		begin
			buffer_re[0]<=x0;
			buffer_im[0]<=0;
			buffer_re[1]<=x4;
			buffer_im[1]<=0;
			buffer_re[2]<=x2;
			buffer_im[2]<=0;
			buffer_re[3]<=x6;
			buffer_im[3]<=0;
			buffer_re[4]<=x1;
			buffer_im[4]<=0;
			buffer_re[5]<=x5;
			buffer_im[5]<=0;
			buffer_re[6]<=x3;
			buffer_im[6]<=0;
			buffer_re[7]<=x7;
			buffer_im[7]<=0;
		end
		else if(status==FFTING)
		begin
			if(busy_del&en)
			begin
				buffer_re[addr1_del]<=bf_out1_re;
				buffer_im[addr1_del]<=bf_out1_im;
				buffer_re[addr2_del]<=bf_out2_re;
				buffer_im[addr2_del]<=bf_out2_im;
			end
		end
		else if(status==ABSING)
			buffer_re[abscntr]<=abs_out;

	/* a kimenet az abszolutertek */
	assign o0=buffer_re[0];
	assign o1=buffer_re[1];
	assign o2=buffer_re[2];
	assign o3=buffer_re[3];
	assign o4=buffer_re[4];
	assign o5=buffer_re[5];
	assign o6=buffer_re[6];
	assign o7=buffer_re[7];

endmodule

module tb_butterfly_fft8;

	/* bemenetek */
	reg clk, rst, start;
	reg signed [12:0] x0,x1,x2,x3,x4,x5,x6,x7;

	/* kimenetek */
	wire busy;
	wire signed [12:0] o0,o1,o2,o3,o4,o5,o6,o7;

	fft8 uut(clk,rst,start,busy,x0,x1,x2,x3,x4,x5,x6,x7,o0,o1,o2,o3,o4,o5,o6,o7);
	
	initial begin
		clk=0;
		rst=1;
		start=0;
		#100;
		rst=0;
		#6 //[1 1 1 1 1 1 1 1]  -->  [1 0 0 0 0 0 0 0]
		x0=13'b0111111111111;
		x1=13'b0111111111111;
		x2=13'b0111111111111;
		x3=13'b0111111111111;
		x4=13'b0111111111111;
		x5=13'b0111111111111;
		x6=13'b0111111111111;
		x7=13'b0111111111111;
		start=1;
		#10
		start=0;
		#600 //[-1 1 -1 1 -1 1 -1 1]  -->  [0 0 0 0 1 0 0 0]
		x0=13'b1000000000000;
		x1=13'b0111111111111;
		x2=13'b1000000000000;
		x3=13'b0111111111111;
		x4=13'b1000000000000;
		x5=13'b0111111111111;
		x6=13'b1000000000000;
		x7=13'b0111111111111;
		start=1;
		#10
		start=0;
		#600 //[1 0 -1/4 0 1 0 1/4 0]  -->  [1/4  1/16  1/4  1/16  1/4  1/16  1/4  1/16]
		x0=13'b0111111111111;
		x1=13'b0000000000000;
		x2=13'b1110000000000;
		x3=13'b0000000000000;
		x4=13'b0111111111111;
		x5=13'b0000000000000;
		x6=13'b0010000000000;
		x7=13'b0000000000000;
		start=1;
		#10
		start=0;
	end

always #5 clk<=~clk;

endmodule
