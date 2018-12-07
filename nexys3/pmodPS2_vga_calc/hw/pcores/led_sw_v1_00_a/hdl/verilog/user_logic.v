/*************************************************************/
/*                                                           */
/* A Nexys 3 kartya LED-jeit es kapcsoloit kezelo periferia  */
/*                                                           */
/*    - BAZISCIM+0: LED-ek (irhato es visszaolvashato)       */
/*    - BAZISCIM+4: kapcsolok (csak olvashato)               */
/*    - mindket regiszter also bajtjan van az ervenyes adat  */
/*                                                           */
/*************************************************************/

`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a

module user_logic #(
	parameter C_NUM_REG                       = 2,
	parameter C_SLV_DWIDTH                    = 32
)(
	input                                     Bus2IP_Clk,
	input                                     Bus2IP_Resetn,
	input      [C_SLV_DWIDTH-1 : 0]           Bus2IP_Data,
	input      [C_SLV_DWIDTH/8-1 : 0]         Bus2IP_BE,
	input      [C_NUM_REG-1 : 0]              Bus2IP_RdCE,
	input      [C_NUM_REG-1 : 0]              Bus2IP_WrCE,
	output reg [C_SLV_DWIDTH-1 : 0]           IP2Bus_Data,
	output                                    IP2Bus_RdAck,
	output                                    IP2Bus_WrAck,
	output                                    IP2Bus_Error,
	output reg [7:0]                          led,
	input      [7:0]                          sw
);

	/* iras a LED-ekre (BAZISCIM + 0) */
	always@(Bus2IP_Clk)
		if(~Bus2IP_Resetn)
			led<=8'd0;
		else if(Bus2IP_WrCE[1]&(Bus2IP_BE==4'b1111))
			led<=Bus2IP_Data[7:0];

	/* olvasas */
	always@(*)
		case(Bus2IP_RdCE)
			2'b10:   IP2Bus_Data  <= {24'd0, led}; //BAZIS+0: LED-ek visszaolvasasa
			2'b01:   IP2Bus_Data  <= {24'd0, sw};  //BAZIS+4: kapcsolok beolvasasa
			default: IP2Bus_Data  <= 32'd0;
		endcase
			
	/* buszjelek megajtasa */
	reg wrack;
	always@(posedge Bus2IP_Clk) wrack<=|Bus2IP_WrCE;
	assign IP2Bus_WrAck = wrack;
	assign IP2Bus_RdAck = |Bus2IP_RdCE;
	assign IP2Bus_Error = 1'b0;

endmodule
