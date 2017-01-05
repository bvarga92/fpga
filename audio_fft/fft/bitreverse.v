/********************************************************************/
/*                                                                  */
/* Egy szam bitsorrendjet megfordito kombinacios logika.            */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module bitreverse(input[6:0] in, output[6:0] out);

	genvar i;
	generate
		for(i=0;i<7;i=i+1)
		begin: bitrevorder
			assign out[i]=in[6-i];
		end
	endgenerate

endmodule
