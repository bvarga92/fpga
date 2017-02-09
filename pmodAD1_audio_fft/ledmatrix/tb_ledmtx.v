/********************************************************************/
/*                                                                  */
/* Testbench a LED matrix vezerlohoz.                               */
/*                                                                  */
/********************************************************************/

`timescale 1ns / 1ps

module tb_ledmtx;

	/* bemenetek */
	reg rst, clk, enn;
	reg[23:0] ram_data;

	/* kimenetek */
	wire sclk, oe, lat, r1, g1, b1, r2, g2, b2, done;
	wire[2:0] rowaddr;
	wire[8:0] ram_addr;

	ledmtx uut(
		.rst(rst), 
		.clk(clk), 
		.enn(enn), 
		.rowaddr(rowaddr), 
		.sclk(sclk), 
		.oe(oe), 
		.lat(lat), 
		.r1(r1), 
		.g1(g1), 
		.b1(b1), 
		.r2(r2), 
		.g2(g2), 
		.b2(b2), 
		.ram_addr(ram_addr), 
		.ram_data(ram_data),
		.done(done)
	);

	initial begin
		rst=1;
		clk=0;
		enn=0;
		//            B2   G2   R2   B1   G1   R1    
		ram_data=24'b0000_0000_0010_0000_0000_0001;
		#100;
		rst=0;
	end
	
	always #5 clk<=~clk;
      
endmodule
