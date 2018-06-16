module mul(
	input           clk,
	input           rst,
	input     [3:0] in1,
	input     [3:0] in2,
	output reg[7:0] out //out=in1*in2
);

	reg[3:0] temp;
	reg[7:0] res;
	always@(posedge clk)
		if(rst)
		begin
			out<=0;
			res<=0;
			temp<=in2;
		end
		else if((|temp)&(|in1))
		begin
			temp<=temp-1'b1;
			res<=res+in1;
		end
		else
		begin
			out<=res;
			res<=0;
			temp<=in2;
		end

endmodule
