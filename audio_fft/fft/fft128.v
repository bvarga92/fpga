/********************************************************************/
/*                                                                  */
/* 128 pontos, szekvencialis FFT modul.                             */
/*                                                                  */
/*   - A start impulzus hatasara helyben elvegzi a transzformaciot  */
/*     a modulhoz kapcsolat blokk RAM tartalman                     */
/*   - Az eredmeny a logaritmikus amplitudospektrum!                */
/*   - A teljes konverzios ido 1474 orajel (14.74 us)               */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module fft128(
		input clk,                              //orajel
		input rst,                              //reset
		output reg ram_we_a, ram_we_b,          //RAM iras engedelyezo jelei
		output reg[6:0] ram_addr_a, ram_addr_b, //RAM cimvezetekei
		output reg[25:0] ram_din_a, ram_din_b,  //RAM bemenetei
		input[25:0] ram_dout_a, ram_dout_b,     //RAM kimenetei
		input start,                            //inditoimpulzus (1 orajel)
		output busy                             //alacsony lesz, amikor kesz vagyunk
	);

	wire signed [12:0] twiddle_re, twiddle_im; //aktualis twiddle factor (w)
	wire signed [12:0] bfu_in1_re, bfu_in1_im, bfu_in2_re, bfu_in2_im; //butterfly bemenete
	wire signed [12:0] bfu_out1_re, bfu_out1_im, bfu_out2_re, bfu_out2_im; //butterfly kimenete
	
	/* butterfly egyseg */
	butterfly bfu(
		.clk(clk),
		.w_re(twiddle_re),
		.w_im(twiddle_im),
		.x1_re(bfu_in1_re),
		.x1_im(bfu_in1_im),
		.x2_re(bfu_in2_re),
		.x2_im(bfu_in2_im),
		.y1_re(bfu_out1_re),
		.y1_im(bfu_out1_im),
		.y2_re(bfu_out2_re),
		.y2_im(bfu_out2_im)
	);
	
	/* statuszregiszter */
	reg[1:0] status;
	parameter IDLE=2'b00;
	parameter FFTING=2'b01;
	parameter ABSING=2'b11;
	
	/* szamlalok az utemezeshez */
	wire en;
	reg[1:0] encntr; //orajeloszto
	reg[2:0] i; //hanyadik FFT szint
	reg[5:0] j; //szinten belul hanyadik butterfly muvelet
	always@(posedge clk)
		if(rst|start|(encntr==2'd2))
			encntr<=0;
		else if(status==FFTING)
			encntr<=encntr+1'b1;
	assign en=(encntr==2'd2);
	always@(posedge clk)
		if(rst)
		begin
			i<=0;
			j<=0;
		end
		else if((status==FFTING)&en)
			if(j==6'd63) //kesz vagyunk a szinttel
			begin
				j<=0;
				if(i==3'd6) //kesz vagyunk a teljes FFT-vel
					i<=0;
				else
					i<=i+1'b1;
			end
			else
				j<=j+1'b1;

	/* abszolutertek kepzese a kimeneten */
	reg[7:0] abscntr;
	always@(posedge clk)
		if(rst|(abscntr==8'd128))
			abscntr<=0;
		else if(status==ABSING)
			abscntr<=abscntr+1'b1;
	wire signed[12:0] abs_out;
	wire[6:0] log_out;
	abs abs_i(
		.y_re(ram_dout_a[12:0]),
		.y_im(ram_dout_a[25:13]),
		.y_abs(abs_out)
	);
	log log_i(
		.n(abs_out[11:5]),
		.nlog(log_out)
	);

	/* allapotgep */
	always@(posedge clk)
		if(rst)
			status<=IDLE;
		else if(start) //kaptunk start jelet, elkezdjuk a transzformaciot
			status<=FFTING;
		else if((i==3'd6)&(j==6'd63)&en) //transzformacio kesz, kepezzuk az abszolutertekeket
			status<=ABSING;
		else if(abscntr==8'd128) //abszolutertekek eloalltak
			status<=IDLE;

	/* aktualis bemenetek es w cimenek eloallitasa */
	wire[6:0] addr1, addr2;
	wire[5:0] twiddle_addr;
	assign addr1=({j,1'b0}<<i)|({j,1'b0}>>(7-i));
	assign addr2=({j,1'b1}<<i)|({j,1'b1}>>(7-i));
	assign bfu_in1_re=ram_dout_a[12:0];
	assign bfu_in1_im=ram_dout_a[25:13];
	assign bfu_in2_re=ram_dout_b[12:0];
	assign bfu_in2_im=ram_dout_b[25:13];
	assign twiddle_addr=j&(12'b111111000000>>i);

	/* twiddle factor lookup table */
	twiddle twiddle_i(
		.addr(twiddle_addr),
		.w_re(twiddle_re),
		.w_im(twiddle_im)
	);

	/* memoriavezerlo */
	always@(*)
		case(status)
			FFTING:
				begin
					ram_addr_a<=addr1;
					ram_addr_b<=addr2;
					ram_din_a<={bfu_out1_im,bfu_out1_re};
					ram_din_b<={bfu_out2_im,bfu_out2_re};
					ram_we_a<=en;
					ram_we_b<=en;
				end
			ABSING:
				begin
					ram_addr_a<=abscntr[6:0];
					ram_addr_b<=abscntr[6:0]-1'b1;
					ram_din_a<=0;
					ram_din_b<={14'd0,log_out,5'd0};
					ram_we_a<=0;
					ram_we_b<=(abscntr==0)?(1'b0):(1'b1);
				end
			default:
				begin
					ram_addr_a<=0;
					ram_addr_b<=0;
					ram_din_a<=0;
					ram_din_b<=0;
					ram_we_a<=0;
					ram_we_b<=0;
				end
		endcase
	
	assign busy=(status!=IDLE);

endmodule
