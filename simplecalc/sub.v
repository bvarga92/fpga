module sub(
	input [3:0] in1,
	input [3:0] in2,
	output[3:0] out //out=|in1-in2|
);

	assign out=(in1>in2)?(in1-in2):(in2-in1);

endmodule
