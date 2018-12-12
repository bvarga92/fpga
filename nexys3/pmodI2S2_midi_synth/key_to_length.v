`timescale 1ns / 1ps
module key_to_length(
	input[7:0] key,
	output reg[10:0] length
);

	always@(*)
		case(key)
			8'h15:   length<=11'd1745;
			8'h16:   length<=11'd1647;
			8'h17:   length<=11'd1555;
			8'h18:   length<=11'd1467;
			8'h19:   length<=11'd1385;
			8'h1A:   length<=11'd1307;
			8'h1B:   length<=11'd1234;
			8'h1C:   length<=11'd1164;
			8'h1D:   length<=11'd1099;
			8'h1E:   length<=11'd1037;
			8'h1F:   length<=11'd979;
			8'h20:   length<=11'd924;
			8'h21:   length<=11'd872;
			8'h22:   length<=11'd823;
			8'h23:   length<=11'd777;
			8'h24:   length<=11'd733;
			8'h25:   length<=11'd692;
			8'h26:   length<=11'd653;
			8'h27:   length<=11'd617;
			8'h28:   length<=11'd582;
			8'h29:   length<=11'd549;
			8'h2A:   length<=11'd518;
			8'h2B:   length<=11'd489;
			8'h2C:   length<=11'd462;
			8'h2D:   length<=11'd436;
			8'h2E:   length<=11'd411;
			8'h2F:   length<=11'd388;
			8'h30:   length<=11'd366;
			8'h31:   length<=11'd346;
			8'h32:   length<=11'd326;
			8'h33:   length<=11'd308;
			8'h34:   length<=11'd291;
			8'h35:   length<=11'd274;
			8'h36:   length<=11'd259;
			8'h37:   length<=11'd244;
			8'h38:   length<=11'd231;
			8'h39:   length<=11'd218;
			8'h3A:   length<=11'd205;
			8'h3B:   length<=11'd194;
			8'h3C:   length<=11'd183;
			8'h3D:   length<=11'd173;
			8'h3E:   length<=11'd163;
			8'h3F:   length<=11'd154;
			8'h40:   length<=11'd145;
			8'h41:   length<=11'd137;
			8'h42:   length<=11'd129;
			8'h43:   length<=11'd122;
			8'h44:   length<=11'd115;
			8'h45:   length<=11'd109;
			8'h46:   length<=11'd102;
			8'h47:   length<=11'd97;
			8'h48:   length<=11'd91;
			8'h49:   length<=11'd86;
			8'h4A:   length<=11'd81;
			8'h4B:   length<=11'd77;
			8'h4C:   length<=11'd72;
			8'h4D:   length<=11'd68;
			8'h4E:   length<=11'd64;
			8'h4F:   length<=11'd61;
			8'h50:   length<=11'd57;
			8'h51:   length<=11'd54;
			8'h52:   length<=11'd51;
			8'h53:   length<=11'd48;
			8'h54:   length<=11'd45;
			8'h55:   length<=11'd43;
			8'h56:   length<=11'd40;
			8'h57:   length<=11'd38;
			8'h58:   length<=11'd36;
			8'h59:   length<=11'd34;
			8'h5A:   length<=11'd32;
			8'h5B:   length<=11'd30;
			8'h5C:   length<=11'd28;
			8'h5D:   length<=11'd27;
			8'h5E:   length<=11'd25;
			8'h5F:   length<=11'd24;
			8'h60:   length<=11'd22;
			8'h61:   length<=11'd21;
			8'h62:   length<=11'd20;
			8'h63:   length<=11'd19;
			8'h64:   length<=11'd18;
			8'h65:   length<=11'd17;
			8'h66:   length<=11'd16;
			8'h67:   length<=11'd15;
			8'h68:   length<=11'd14;
			8'h69:   length<=11'd13;
			8'h6A:   length<=11'd12;
			8'h6B:   length<=11'd12;
			8'h6C:   length<=11'd11;
			default: length<=11'd109;
		endcase

endmodule