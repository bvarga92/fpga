`timescale 1ns / 1ps

module testbench;
	reg Bus2IP_Clk;
	reg Bus2IP_Resetn;
	reg[31:0] Bus2IP_Addr;
	reg[0:0] Bus2IP_CS;
	reg Bus2IP_RNW;
	reg[31:0] Bus2IP_Data;
	reg[3:0] Bus2IP_BE;
	reg[0:0] Bus2IP_RdCE;
	reg[0:0] Bus2IP_WrCE;
	wire[31:0] IP2Bus_Data;
	wire IP2Bus_RdAck;
	wire IP2Bus_WrAck;
	wire IP2Bus_Error;
	wire hsync;
	wire vsync;
	wire[7:0] rgb;

	user_logic uut(
		.Bus2IP_Clk(Bus2IP_Clk), 
		.Bus2IP_Resetn(Bus2IP_Resetn), 
		.Bus2IP_Addr(Bus2IP_Addr), 
		.Bus2IP_CS(Bus2IP_CS), 
		.Bus2IP_RNW(Bus2IP_RNW), 
		.Bus2IP_Data(Bus2IP_Data), 
		.Bus2IP_BE(Bus2IP_BE), 
		.Bus2IP_RdCE(Bus2IP_RdCE), 
		.Bus2IP_WrCE(Bus2IP_WrCE), 
		.IP2Bus_Data(IP2Bus_Data), 
		.IP2Bus_RdAck(IP2Bus_RdAck), 
		.IP2Bus_WrAck(IP2Bus_WrAck), 
		.IP2Bus_Error(IP2Bus_Error), 
		.hsync(hsync), 
		.vsync(vsync), 
		.rgb(rgb)
	);

	initial begin
		Bus2IP_Clk=0;
		Bus2IP_Resetn=0;
		Bus2IP_Addr=0;
		Bus2IP_CS=0;
		Bus2IP_RNW=0;
		Bus2IP_Data=0;
		Bus2IP_BE=0;
		Bus2IP_RdCE=0;
		Bus2IP_WrCE=0;
		#100;
		Bus2IP_Resetn=1;
	end
      
	always #5 Bus2IP_Clk<=~Bus2IP_Clk;
		
endmodule
