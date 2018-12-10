`timescale 1ns / 1ps

module dsp_block #(
	parameter A_REG=2,
	parameter B_REG=2
)(
	input               clk,
	input  signed[17:0] a, b, 
	input  signed[47:0] c,
	output signed[17:0] bco,
	output signed[47:0] p     //p=a*b+c
);

	reg signed[17:0] a_reg[A_REG-1:0], b_reg[B_REG-1:0];
	reg signed[35:0] m_reg;
	reg signed[47:0] p_reg;

	integer i;

	always@(posedge clk)
	for(i=0; i<A_REG; i=i+1)
		a_reg[i]<=(i==0)?a:a_reg[i-1];

	always@(posedge clk)
	for(i=0; i<B_REG; i=i+1)
		b_reg[i]<=(i==0)?b:b_reg[i-1];

	assign bco=b_reg[B_REG-1];

	always@(posedge clk)
	begin
		m_reg<=a_reg[A_REG-1]*b_reg[B_REG-1];
		p_reg<=m_reg+c;
	end

	assign p=p_reg;

endmodule
