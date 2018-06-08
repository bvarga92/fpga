`timescale 1 ns / 1 ps

module toplevel(
	input clk,
	input reset,
	output[18:0] cellular_ram_addr,
	output cellular_ram_ce_n,
	inout[7:0] cellular_ram_dq_io,
	output cellular_ram_oen,
	output cellular_ram_wen,
	output[1:0] led,
	output[2:0] rgb,
	input btn1
);

	wire clk;
	wire reset;
	wire[18:0] cellular_ram_addr;
	wire cellular_ram_ce_n;
	wire[0:0] cellular_ram_dq_i_0;
	wire[1:1] cellular_ram_dq_i_1;
	wire[2:2] cellular_ram_dq_i_2;
	wire[3:3] cellular_ram_dq_i_3;
	wire[4:4] cellular_ram_dq_i_4;
	wire[5:5] cellular_ram_dq_i_5;
	wire[6:6] cellular_ram_dq_i_6;
	wire[7:7] cellular_ram_dq_i_7;
	wire[0:0] cellular_ram_dq_io_0;
	wire[1:1] cellular_ram_dq_io_1;
	wire[2:2] cellular_ram_dq_io_2;
	wire[3:3] cellular_ram_dq_io_3;
	wire[4:4] cellular_ram_dq_io_4;
	wire[5:5] cellular_ram_dq_io_5;
	wire[6:6] cellular_ram_dq_io_6;
	wire[7:7] cellular_ram_dq_io_7;
	wire[0:0] cellular_ram_dq_o_0;
	wire[1:1] cellular_ram_dq_o_1;
	wire[2:2] cellular_ram_dq_o_2;
	wire[3:3] cellular_ram_dq_o_3;
	wire[4:4] cellular_ram_dq_o_4;
	wire[5:5] cellular_ram_dq_o_5;
	wire[6:6] cellular_ram_dq_o_6;
	wire[7:7] cellular_ram_dq_o_7;
	wire[0:0] cellular_ram_dq_t_0;
	wire[1:1] cellular_ram_dq_t_1;
	wire[2:2] cellular_ram_dq_t_2;
	wire[3:3] cellular_ram_dq_t_3;
	wire[4:4] cellular_ram_dq_t_4;
	wire[5:5] cellular_ram_dq_t_5;
	wire[6:6] cellular_ram_dq_t_6;
	wire[7:7] cellular_ram_dq_t_7;
	wire cellular_ram_oen;
	wire cellular_ram_wen;
	wire[1:0] led_tri_o;
	wire[2:0] rgb_tri_o;
	wire[1:0] btn_tri_i;

	IOBUF cellular_ram_dq_iobuf_0(
		.I(cellular_ram_dq_o_0),
		.IO(cellular_ram_dq_io[0] ),
		.O(cellular_ram_dq_i_0),
		.T(cellular_ram_dq_t_0)
	);
	IOBUF cellular_ram_dq_iobuf_1(
		.I(cellular_ram_dq_o_1),
		.IO(cellular_ram_dq_io[1] ),
		.O(cellular_ram_dq_i_1),
		.T(cellular_ram_dq_t_1)
	);
	IOBUF cellular_ram_dq_iobuf_2(
		.I(cellular_ram_dq_o_2),
		.IO(cellular_ram_dq_io[2] ),
		.O(cellular_ram_dq_i_2),
		.T(cellular_ram_dq_t_2)
	);
	IOBUF cellular_ram_dq_iobuf_3(
		.I(cellular_ram_dq_o_3),
		.IO(cellular_ram_dq_io[3] ),
		.O(cellular_ram_dq_i_3),
		.T(cellular_ram_dq_t_3)
	);
	IOBUF cellular_ram_dq_iobuf_4(
		.I(cellular_ram_dq_o_4),
		.IO(cellular_ram_dq_io[4] ),
		.O(cellular_ram_dq_i_4),
		.T(cellular_ram_dq_t_4)
	);
	IOBUF cellular_ram_dq_iobuf_5(
		.I(cellular_ram_dq_o_5),
		.IO(cellular_ram_dq_io[5] ),
		.O(cellular_ram_dq_i_5),
		.T(cellular_ram_dq_t_5)
	);
	IOBUF cellular_ram_dq_iobuf_6(
		.I(cellular_ram_dq_o_6),
		.IO(cellular_ram_dq_io[6] ),
		.O(cellular_ram_dq_i_6),
		.T(cellular_ram_dq_t_6)
	);
	IOBUF cellular_ram_dq_iobuf_7(
		.I(cellular_ram_dq_o_7),
		.IO(cellular_ram_dq_io[7] ),
		.O(cellular_ram_dq_i_7),
		.T(cellular_ram_dq_t_7)
	);

	system system_i(
		.clk(clk),
		.reset(reset),
		.cellular_ram_addr(cellular_ram_addr),
		.cellular_ram_ce_n(cellular_ram_ce_n),
		.cellular_ram_dq_i({cellular_ram_dq_i_7,cellular_ram_dq_i_6,cellular_ram_dq_i_5,cellular_ram_dq_i_4,cellular_ram_dq_i_3,cellular_ram_dq_i_2,cellular_ram_dq_i_1,cellular_ram_dq_i_0}),
		.cellular_ram_dq_o({cellular_ram_dq_o_7,cellular_ram_dq_o_6,cellular_ram_dq_o_5,cellular_ram_dq_o_4,cellular_ram_dq_o_3,cellular_ram_dq_o_2,cellular_ram_dq_o_1,cellular_ram_dq_o_0}),
		.cellular_ram_dq_t({cellular_ram_dq_t_7,cellular_ram_dq_t_6,cellular_ram_dq_t_5,cellular_ram_dq_t_4,cellular_ram_dq_t_3,cellular_ram_dq_t_2,cellular_ram_dq_t_1,cellular_ram_dq_t_0}),
		.cellular_ram_oen(cellular_ram_oen),
		.cellular_ram_wen(cellular_ram_wen),
		.led_tri_o(led),
		.rgb_tri_o(rgb),
		.btn1_tri_i(btn1)
	);

endmodule
