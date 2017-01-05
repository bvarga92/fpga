`timescale 1ns / 1ps

module testbench;
	reg Bus2IP_Clk;
	reg Bus2IP_Resetn;
	reg[31:0] Bus2IP_Data;
	reg[3:0] Bus2IP_BE;
	reg[1:0] Bus2IP_RdCE;
	reg[1:0] Bus2IP_WrCE;
	reg ps2_clk;
	reg ps2_data;
	wire[31:0] IP2Bus_Data;
	wire IP2Bus_RdAck;
	wire IP2Bus_WrAck;
	wire IP2Bus_Error;

	user_logic uut(
		.Bus2IP_Clk(Bus2IP_Clk), 
		.Bus2IP_Resetn(Bus2IP_Resetn), 
		.Bus2IP_Data(Bus2IP_Data), 
		.Bus2IP_BE(Bus2IP_BE), 
		.Bus2IP_RdCE(Bus2IP_RdCE), 
		.Bus2IP_WrCE(Bus2IP_WrCE), 
		.IP2Bus_Data(IP2Bus_Data), 
		.IP2Bus_RdAck(IP2Bus_RdAck), 
		.IP2Bus_WrAck(IP2Bus_WrAck), 
		.IP2Bus_Error(IP2Bus_Error), 
		.ps2_clk(ps2_clk), 
		.ps2_data(ps2_data)
	);

	task ps2Send(input[7:0] data);
		integer i;
		begin
			@(posedge Bus2IP_Clk) ps2_data=0; //startbit
			@(posedge Bus2IP_Clk);
			for(i=0;i<10;i=i+1)
			begin
				@(negedge Bus2IP_Clk) ps2_clk=0;
				@(negedge Bus2IP_Clk);
				@(negedge Bus2IP_Clk);
				@(posedge Bus2IP_Clk)
				begin
					ps2_clk=1;
					if(i==8)
						ps2_data=~^data; //paritasbit
					else if(i==9)
						ps2_data=1; //stopbit
					else
						ps2_data=data[i]; //adat
				end
				@(posedge Bus2IP_Clk);
				@(posedge Bus2IP_Clk);
			end
			@(negedge Bus2IP_Clk) ps2_clk=0;
			@(negedge Bus2IP_Clk);
			@(negedge Bus2IP_Clk);
			@(posedge Bus2IP_Clk) ps2_clk=1;
		end
	endtask

	initial begin
		Bus2IP_Clk=0;
		Bus2IP_Resetn=0;
		Bus2IP_Data=0;
		Bus2IP_BE=0;
		Bus2IP_RdCE=0;
		Bus2IP_WrCE=0;
		ps2_clk=1;
		ps2_data=1;
		#100;
		Bus2IP_Resetn=1;
		#100;
		/* elkuldjuk az A billentyu scan kodjat (0x1C) */
		ps2Send(8'h1C);
		#50;
		/* olvasas a FIFO-bol: az A betu ASCII kodjat kell kapnunk (0x41) */
		@(posedge Bus2IP_Clk)
		begin
			Bus2IP_BE=4'b1111;
			Bus2IP_RdCE=2'b01;
		end
		@(posedge Bus2IP_Clk)
		begin
			Bus2IP_BE=0;
			Bus2IP_RdCE=0;
		end
	end

	always #5 Bus2IP_Clk<=~Bus2IP_Clk;

endmodule
