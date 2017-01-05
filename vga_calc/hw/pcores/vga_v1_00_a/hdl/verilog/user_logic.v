/*************************************************************/
/*                                                           */
/* VGA meghajto periferia                                    */
/*                                                           */
/*    - idozites: 800x600 @ 60 Hz                            */
/*    - felbontas: 100x75 (8x8 pixeles egysegek)             */
/*    - cimzes: 128*sor + oszlop                             */
/*    - a cimzeshez 14 bit kell --> C_S_AXI_MIN_SIZE=0x3fff  */
/*                                                           */
/*************************************************************/

`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a

module user_logic #(
	parameter C_NUM_REG                       = 1,
	parameter C_SLV_DWIDTH                    = 32
)
(
	input                                     Bus2IP_Clk,
	input                                     Bus2IP_Resetn,
	input      [31 : 0]                       Bus2IP_Addr,
	input      [0 : 0]                        Bus2IP_CS,
	input                                     Bus2IP_RNW,
	input      [C_SLV_DWIDTH-1 : 0]           Bus2IP_Data,
	input      [C_SLV_DWIDTH/8-1 : 0]         Bus2IP_BE,
	input      [C_NUM_REG-1 : 0]              Bus2IP_RdCE,
	input      [C_NUM_REG-1 : 0]              Bus2IP_WrCE,
	output     [C_SLV_DWIDTH-1 : 0]           IP2Bus_Data,
	output                                    IP2Bus_RdAck,
	output                                    IP2Bus_WrAck,
	output                                    IP2Bus_Error,
	output                                    hsync,
	output                                    vsync,
	output     [7:0]                          rgb
);

	/* 50 MHz-es pixel engedelyezo jel */
	reg en;
	always@(posedge Bus2IP_Clk) en<=(~Bus2IP_Resetn)?0:~en;

	/* sorszinkron */
	reg[10:0] hcnt;
	always@(posedge Bus2IP_Clk)
		if(~Bus2IP_Resetn)
			hcnt<=0;
		else if(en)
			hcnt<=(hcnt==1039)?(11'd0):(hcnt+1'b1);
	assign hsync=(hcnt<856)|(hcnt>975);

	/* kepszinkron */
	reg[9:0] vcnt;
	always@(posedge Bus2IP_Clk)
		if(~Bus2IP_Resetn)
			vcnt<=0;
		else if(en&(hcnt==1039))
			vcnt<=(vcnt==665)?(10'd0):(vcnt+1'b1);
	assign vsync=(vcnt<637)|(vcnt>642);

	/* frame buffer (8x8-as egysegek, cim=128*sor+oszlop) */
	wire[7:0] rd_data;
	dp_bram_16384x8 framebuffer(
		.clk(Bus2IP_Clk),
		.rst(~Bus2IP_Resetn),
		.wr_en(Bus2IP_CS[0]&~Bus2IP_RNW),
		.wr_addr(Bus2IP_Addr[13:0]),
		.wr_data(Bus2IP_Data[7:0]),
		.rd_addr({vcnt[9:3],hcnt[9:3]}),
		.rd_data(rd_data)
	);
	reg valid;
	always@(posedge Bus2IP_Clk) valid<=((hcnt<800)&(vcnt<600));
	assign rgb=((~Bus2IP_Resetn)|(~valid))?(8'd0):rd_data;

	/* buszjelek meghajtasa */
	reg wrack;
	always@(posedge Bus2IP_Clk) wrack<=Bus2IP_CS[0]&~Bus2IP_RNW;
	assign IP2Bus_WrAck = wrack;
	assign IP2Bus_RdAck = Bus2IP_CS[0]&Bus2IP_RNW;
	assign IP2Bus_Data  = 0;
	assign IP2Bus_Error = 1'b0;

endmodule
