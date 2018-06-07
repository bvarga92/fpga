`timescale 1 ns / 1 ps

module toplevel(
	output[18:0] cellular_ram_addr,
	output cellular_ram_ce_n,
	inout[7:0] cellular_ram_dq_io,
	output cellular_ram_oen,
	output cellular_ram_wen,
	inout[1:0] led_2bits_tri_io,
	inout [2:0]rgb_led_tri_io,
	input reset,
	input sys_clock
);

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
	wire[0:0] led_2bits_tri_i_0;
	wire[1:1] led_2bits_tri_i_1;
	wire[0:0] led_2bits_tri_io_0;
	wire[1:1] led_2bits_tri_io_1;
	wire[0:0] led_2bits_tri_o_0;
	wire[1:1] led_2bits_tri_o_1;
	wire[0:0] led_2bits_tri_t_0;
	wire[1:1] led_2bits_tri_t_1;
	wire[0:0] rgb_led_tri_i_0;
	wire[1:1] rgb_led_tri_i_1;
	wire[2:2] rgb_led_tri_i_2;
	wire[0:0] rgb_led_tri_io_0;
	wire[1:1] rgb_led_tri_io_1;
	wire[2:2] rgb_led_tri_io_2;
	wire[0:0] rgb_led_tri_o_0;
	wire[1:1] rgb_led_tri_o_1;
	wire[2:2] rgb_led_tri_o_2;
	wire[0:0] rgb_led_tri_t_0;
	wire[1:1] rgb_led_tri_t_1;
	wire[2:2] rgb_led_tri_t_2;
	wire reset;
	wire sys_clock;

	IOBUF cellular_ram_dq_iobuf_0(
		.I(cellular_ram_dq_o_0),
		.IO(cellular_ram_dq_io[0]),
		.O(cellular_ram_dq_i_0),
		.T(cellular_ram_dq_t_0)
	);
	IOBUF cellular_ram_dq_iobuf_1(
		.I(cellular_ram_dq_o_1),
		.IO(cellular_ram_dq_io[1]),
		.O(cellular_ram_dq_i_1),
		.T(cellular_ram_dq_t_1)
	);
	IOBUF cellular_ram_dq_iobuf_2(
		.I(cellular_ram_dq_o_2),
		.IO(cellular_ram_dq_io[2]),
		.O(cellular_ram_dq_i_2),
		.T(cellular_ram_dq_t_2)
	);
	IOBUF cellular_ram_dq_iobuf_3(
		.I(cellular_ram_dq_o_3),
		.IO(cellular_ram_dq_io[3]),
		.O(cellular_ram_dq_i_3),
		.T(cellular_ram_dq_t_3)
	);
	IOBUF cellular_ram_dq_iobuf_4(
		.I(cellular_ram_dq_o_4),
		.IO(cellular_ram_dq_io[4]),
		.O(cellular_ram_dq_i_4),
		.T(cellular_ram_dq_t_4)
	);
	IOBUF cellular_ram_dq_iobuf_5(
		.I(cellular_ram_dq_o_5),
		.IO(cellular_ram_dq_io[5]),
		.O(cellular_ram_dq_i_5),
		.T(cellular_ram_dq_t_5)
	);
	IOBUF cellular_ram_dq_iobuf_6(
		.I(cellular_ram_dq_o_6),
		.IO(cellular_ram_dq_io[6]),
		.O(cellular_ram_dq_i_6),
		.T(cellular_ram_dq_t_6)
	);
	IOBUF cellular_ram_dq_iobuf_7(
		.I(cellular_ram_dq_o_7),
		.IO(cellular_ram_dq_io[7]),
		.O(cellular_ram_dq_i_7),
		.T(cellular_ram_dq_t_7)
	);
	IOBUF led_2bits_tri_iobuf_0(
		.I(led_2bits_tri_o_0),
		.IO(led_2bits_tri_io[0]),
		.O(led_2bits_tri_i_0),
		.T(led_2bits_tri_t_0)
	);
	IOBUF led_2bits_tri_iobuf_1(
		.I(led_2bits_tri_o_1),
		.IO(led_2bits_tri_io[1]),
		.O(led_2bits_tri_i_1),
		.T(led_2bits_tri_t_1)
	);
	IOBUF rgb_led_tri_iobuf_0(
		.I(rgb_led_tri_o_0),
		.IO(rgb_led_tri_io[0]),
		.O(rgb_led_tri_i_0),
		.T(rgb_led_tri_t_0)
	);
	IOBUF rgb_led_tri_iobuf_1(
		.I(rgb_led_tri_o_1),
		.IO(rgb_led_tri_io[1]),
		.O(rgb_led_tri_i_1),
		.T(rgb_led_tri_t_1)
	);
	IOBUF rgb_led_tri_iobuf_2(
		.I(rgb_led_tri_o_2),
		.IO(rgb_led_tri_io[2]),
		.O(rgb_led_tri_i_2),
		.T(rgb_led_tri_t_2)
	);

	system system_i(
		.cellular_ram_addr(cellular_ram_addr),
		.cellular_ram_ce_n(cellular_ram_ce_n),
		.cellular_ram_dq_i({cellular_ram_dq_i_7,cellular_ram_dq_i_6,cellular_ram_dq_i_5,cellular_ram_dq_i_4,cellular_ram_dq_i_3,cellular_ram_dq_i_2,cellular_ram_dq_i_1,cellular_ram_dq_i_0}),
		.cellular_ram_dq_o({cellular_ram_dq_o_7,cellular_ram_dq_o_6,cellular_ram_dq_o_5,cellular_ram_dq_o_4,cellular_ram_dq_o_3,cellular_ram_dq_o_2,cellular_ram_dq_o_1,cellular_ram_dq_o_0}),
		.cellular_ram_dq_t({cellular_ram_dq_t_7,cellular_ram_dq_t_6,cellular_ram_dq_t_5,cellular_ram_dq_t_4,cellular_ram_dq_t_3,cellular_ram_dq_t_2,cellular_ram_dq_t_1,cellular_ram_dq_t_0}),
		.cellular_ram_oen(cellular_ram_oen),
		.cellular_ram_wen(cellular_ram_wen),
		.led_2bits_tri_i({led_2bits_tri_i_1,led_2bits_tri_i_0}),
		.led_2bits_tri_o({led_2bits_tri_o_1,led_2bits_tri_o_0}),
		.led_2bits_tri_t({led_2bits_tri_t_1,led_2bits_tri_t_0}),
		.rgb_led_tri_i({rgb_led_tri_i_2,rgb_led_tri_i_1,rgb_led_tri_i_0}),
		.rgb_led_tri_o({rgb_led_tri_o_2,rgb_led_tri_o_1,rgb_led_tri_o_0}),
		.rgb_led_tri_t({rgb_led_tri_t_2,rgb_led_tri_t_1,rgb_led_tri_t_0}),
		.reset(reset),
		.sys_clock(sys_clock)
	);

endmodule
