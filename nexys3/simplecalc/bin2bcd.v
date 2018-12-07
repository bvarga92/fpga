/*****************************************************************/
/*                                                               */
/* 8 bites binaris szamokat alakit at 3 digites BCD formatumba   */
/* shift-add-3 (double dabble) algoritmussal. A konverzio 8      */
/* orajelnyi idot vesz igenybe. A kimenetek mindig ervenyesek.   */
/*                                                               */
/*****************************************************************/

module bin2bcd(
	input           clk,
	input           rst,
	input     [7:0] in,
	output reg[3:0] d2,
	output reg[3:0] d1,
	output reg[3:0] d0
);

reg[3:0] cntr;
always@(posedge clk)
	cntr<=(rst|(cntr==8))?4'd0:(cntr+1'b1);

reg[19:0] w;
always@(posedge clk)
	if(cntr==8)
		w<={12'd0, in};
	else
		w<={(w[19:16]>4)?(w[19:16]+4'd3):w[19:16], (w[15:12]>4)?(w[15:12]+4'd3):w[15:12], (w[11:8]>4)?(w[11:8]+4'd3):w[11:8],w[7:0]} << 1;

always@(posedge clk)
	if(cntr==8)
	begin
		d2<=w[19:16];
		d1<=w[15:12];
		d0<=w[11:8];
	end

endmodule
