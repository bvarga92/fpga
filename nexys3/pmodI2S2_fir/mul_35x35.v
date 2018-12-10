`timescale 1ns / 1ps

module mul_35x35(
	input                clk,
	input  signed[34:0] a, b,
	output signed[69:0] m      //m=a*b, 5 orajel latency
);

	wire signed[17:0] ai[3:0];
	wire signed[17:0] bi[3:0];
	wire signed[17:0] bco[3:0];
	wire signed[47:0] ci[3:0];
	wire signed[47:0] pi[3:0];

	reg signed[34:0] a_dl[2:0];
	reg signed[34:0] b_dl;

	integer i;

	always@(posedge clk)
	begin
		for(i=0; i<3; i= i+1)
			a_dl[i]<=(i==0)?a:a_dl[i-1];
		b_dl <= b;
	end

	assign ai[0]={1'b0, a[16:0]};
	assign bi[0]={1'b0, b[16:0]};
	assign ci[0]=0;
	assign ai[1]=a[34:17];
	assign bi[1]=bco[0];
	assign ci[1]={{17{pi[0][47]}}, pi[0][47:17]};
	assign ai[2]={1'b0, a_dl[0][16:0]};
	assign bi[2]=b_dl[34:17];
	assign ci[2]=pi[1];
	assign ai[3]={1'b0, a_dl[2][34:17]};
	assign bi[3]=bco[2];
	assign ci[3]={{17{pi[2][47]}}, pi[2][47:17]};;

	genvar id;
	generate
		for(id=0; id < 4; id=id+1) 
		begin: GEN_DSP
			dsp_block #(
				.A_REG((id==0 | id==3)?1:2),
				.B_REG((id==2)?2:1)
			) dsp(
				.clk(clk),
				.a(ai[id]), 
				.b(bi[id]), 
				.c(ci[id]),
				.bco(bco[id]),
				.p(pi[id])
			);
		end
	endgenerate

	reg signed[16:0] p0_dl[2:0];
	reg signed[16:0] p2_dl;
	always@(posedge clk)
	begin
		for(i=0; i<3; i= i+1)
			p0_dl[i]<=(i==0)?pi[0][16:0]:p0_dl[i-1];
		p2_dl<=pi[2][16:0];
	end

	assign m={pi[3][35:0], p2_dl, p0_dl[2]};

endmodule
