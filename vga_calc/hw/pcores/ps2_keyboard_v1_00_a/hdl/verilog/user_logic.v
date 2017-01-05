/*************************************************************/
/*                                                           */
/* PS/2 billentyuzetet kezelo periferia                      */
/*                                                           */
/*    - csak bemenet, a billentyuzetnek kuldeni nem tud      */
/*    - a vett karakterek egy 16 mely FIFO-ba kerulnek       */
/*    - a periferia 2 regiszterrel rendelkezik (csak olv.)   */
/*    - BAZISCIM+0: statuszregiszter                         */
/*        - formatum: 00000000_00000000_00000000_000000fe    */
/*        - f: tele van a FIFO, e: ures a FIFO               */
/*    - BAZISCIM+4: olvasas a FIFO-bol                       */
/*        - a kiolvasott adat also bajtja az ASCII kod       */
/*                                                           */
/*************************************************************/

`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a

module user_logic #(
	parameter C_NUM_REG                       = 2,
	parameter C_SLV_DWIDTH                    = 32
)
(
	input                                     Bus2IP_Clk,
	input                                     Bus2IP_Resetn,
	input      [C_SLV_DWIDTH-1 : 0]           Bus2IP_Data,
	input      [C_SLV_DWIDTH/8-1 : 0]         Bus2IP_BE,
	input      [C_NUM_REG-1 : 0]              Bus2IP_RdCE,
	input      [C_NUM_REG-1 : 0]              Bus2IP_WrCE,
	output     [C_SLV_DWIDTH-1 : 0]           IP2Bus_Data,
	output                                    IP2Bus_RdAck,
	output                                    IP2Bus_WrAck,
	output                                    IP2Bus_Error,
	input                                     ps2_clk,
	input                                     ps2_data
);

	/* orajel lefuto elenek detektalasa */
	reg[1:0] ps2_clk_shr;
	always@(posedge Bus2IP_Clk) ps2_clk_shr<={ps2_clk,ps2_clk_shr[1]};
	wire ps2_clk_fall=(ps2_clk_shr==2'b01);

	/* fogadott bitek szamolasa */
	reg[3:0] bitcntr;
	always@(posedge Bus2IP_Clk)
		if(~Bus2IP_Resetn)
			bitcntr<=0;
		else if(ps2_clk_fall)
			bitcntr<=(bitcntr==10)?(4'd0):(bitcntr+1'b1);

	/* bejovo adat mintavetelezese */
	reg[7:0] recv;
	always@(posedge Bus2IP_Clk)
		if(~Bus2IP_Resetn)
			recv<=0;
		else if(ps2_clk_fall&(bitcntr>0)&(bitcntr<9))
			recv<={ps2_data,recv[7:1]};

	/* scan code --> ASCII lookup table */
	reg[7:0] ascii;
	always@(*)
		case(recv)	
			8'h1C:   ascii<=8'h41;
			8'h32:   ascii<=8'h42;
			8'h21:   ascii<=8'h43;
			8'h23:   ascii<=8'h44;
			8'h24:   ascii<=8'h45;
			8'h2B:   ascii<=8'h46;
			8'h34:   ascii<=8'h47;
			8'h33:   ascii<=8'h48;
			8'h43:   ascii<=8'h49;
			8'h3B:   ascii<=8'h4A;
			8'h42:   ascii<=8'h4B;
			8'h4B:   ascii<=8'h4C;
			8'h3A:   ascii<=8'h4D;
			8'h31:   ascii<=8'h4E;
			8'h44:   ascii<=8'h4F;
			8'h4D:   ascii<=8'h50;
			8'h15:   ascii<=8'h51;
			8'h2D:   ascii<=8'h52;
			8'h1B:   ascii<=8'h53;
			8'h2C:   ascii<=8'h54;
			8'h3C:   ascii<=8'h55;
			8'h2A:   ascii<=8'h56;
			8'h1D:   ascii<=8'h57;
			8'h22:   ascii<=8'h58;
			8'h35:   ascii<=8'h59;
			8'h1A:   ascii<=8'h5A;
			8'h45:   ascii<=8'h30;
			8'h16:   ascii<=8'h31;
			8'h1E:   ascii<=8'h32;
			8'h26:   ascii<=8'h33;
			8'h25:   ascii<=8'h34;
			8'h2E:   ascii<=8'h35;
			8'h36:   ascii<=8'h36;
			8'h3D:   ascii<=8'h37;
			8'h3E:   ascii<=8'h38;
			8'h46:   ascii<=8'h39;
			8'h70:   ascii<=8'h30;
			8'h69:   ascii<=8'h31;
			8'h72:   ascii<=8'h32;
			8'h7a:   ascii<=8'h33;
			8'h6b:   ascii<=8'h34;
			8'h73:   ascii<=8'h35;
			8'h74:   ascii<=8'h36;
			8'h6c:   ascii<=8'h37;
			8'h75:   ascii<=8'h38;
			8'h7d:   ascii<=8'h39;
			8'h79:   ascii<=8'h2b;
			8'h7b:   ascii<=8'h2d;
			8'h7c:   ascii<=8'h2a;
			8'h0E:   ascii<=8'h60;
			8'h4E:   ascii<=8'h2D;
			8'h55:   ascii<=8'h3D;
			8'h5C:   ascii<=8'h5C;
			8'h29:   ascii<=8'h20;
			8'h54:   ascii<=8'h5B;
			8'h5B:   ascii<=8'h5D;
			8'h4C:   ascii<=8'h3B;
			8'h52:   ascii<=8'h27;
			8'h41:   ascii<=8'h2C;
			8'h49:   ascii<=8'h2E;
			8'h4A:   ascii<=8'h2F;
			8'h5A:   ascii<=8'h0D;
			8'h66:   ascii<=8'h08;
			8'hF0:   ascii<=8'hF0; //felengedes prefix
			default: ascii<=8'h23;
		endcase

	/* veteli FIFO */
	wire fifo_empty, fifo_full;
	wire[7:0] fifo_data;
	fifo16 fifo16_i(
		.clk(Bus2IP_Clk),
		.rst(~Bus2IP_Resetn),
		.wr(ps2_clk_fall&(bitcntr==9)),
		.rd(Bus2IP_RdCE[0]),
		.din(ascii),
		.dout(fifo_data),
		.empty(fifo_empty),
		.full(fifo_full)
	);
	
	/* olvasas */
	reg[31:0] rd_reg;
	assign IP2Bus_Data=rd_reg;
	always@(*)
		case(Bus2IP_RdCE)
			2'b10:   rd_reg<={30'd0,fifo_full,fifo_empty}; //BAZISCIM+0: statusz
			2'b01:   rd_reg<={24'd0,fifo_data};            //BAZISCIM+4: adat
			default: rd_reg<=32'd0;
		endcase
		
	/* buszjelek meghajtasa */
	assign IP2Bus_RdAck = |Bus2IP_RdCE;
	assign IP2Bus_WrAck = |Bus2IP_WrCE;
	assign IP2Bus_Error = 1'b0;

endmodule
