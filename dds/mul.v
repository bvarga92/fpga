/********************************************************************/
/*                                                                  */
/* Szorzo modul (Xilinx Spartan-6: DSP48A1 blokk).                  */
/*                                                                  */
/********************************************************************/

module mul(
	input clk,
	input rst,
	input signed [17:0] a,
	input signed [17:0] b,
	output signed [35:0] p
);

(* USE_DSP48="yes" *)reg signed [35:0] preg;

always@(posedge clk)
	preg<=rst?0:a*b;

assign p=preg;

endmodule
