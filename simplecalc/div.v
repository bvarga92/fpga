module div(
	input           clk,
	input           rst,
	input     [3:0] in1,
	input     [3:0] in2,
	output reg[3:0] out //out=in1/in2
);

	reg[3:0] temp, res;
	always@(posedge clk)
		if(rst)
		begin
			out<=0;
			res<=0;
			temp<=in1;
		end
		else if((temp>=in2)&(|in2))
		begin
			temp<=temp-in2;
			res<=res+1'b1;
		end
		else
		begin
			out<=res;
			res<=0;
			temp<=in1;
		end

endmodule
