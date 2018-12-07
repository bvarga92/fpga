/********************************************************************/
/*                                                                  */
/* Elemi butterfly modul.                                           */
/*                                                                  */
/* - Egy orajel alatt elvegzi az alabbi szamitast:                  */
/*        y1 = (x1 + w*x2)/2                                        */
/*        y2 = (x1 - w*x2)/2                                        */
/* - Minden be- es kimenet 13 bites, elojeles, fixpontos szam s.12  */
/*   formatumban (-1 ... 0.9998).                                   */
/* - Az x-ek nem lehetnek negativak.                                */
/* - Megj.: eroforrastakarekosabb lenne nem 1 orajel alatt vegezni  */
/*   az osszes muveletet.                                           */
/*                                                                  */
/********************************************************************/

module butterfly(
	input clk,
	input signed [12:0] w_re, w_im,
	input signed [12:0] x1_re, x1_im,
	input signed [12:0] x2_re, x2_im,
	output signed [12:0] y1_re, y1_im,
	output signed [12:0] y2_re, y2_im
);

	/* szorzasok (s.12 * s.12 = s1.24) */
	reg signed [25:0] a, b, c, d;
	always@(posedge clk)
	begin
		a<=w_re*x2_re;
		b<=w_im*x2_im;
		c<=w_re*x2_im;
		d<=w_im*x2_re;
	end

	/* osszeadasok elojelkiterjesztesekkel (s2.12) */
	wire signed [14:0] y1_re2, y1_im2, y2_re2, y2_im2;
	assign y1_re2={{2{x1_re[12]}},x1_re}+{a[25],a[25:12]}-{b[25],b[25:12]};
	assign y1_im2={{2{x1_im[12]}},x1_im}+{c[25],c[25:12]}+{d[25],d[25:12]};
	assign y2_re2={{2{x1_re[12]}},x1_re}-{a[25],a[25:12]}+{b[25],b[25:12]};
	assign y2_im2={{2{x1_im[12]}},x1_im}-{c[25],c[25:12]}-{d[25],d[25:12]};

	/* osztas 2-vel */
	assign y1_re=y1_re2[13:1];
	assign y1_im=y1_im2[13:1];
	assign y2_re=y2_re2[13:1];
	assign y2_im=y2_im2[13:1];

endmodule
