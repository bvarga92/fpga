/********************************************************************/
/*                                                                  */
/* Kombinacios logika komplex szam abszolutertekenek kozelitesere.  */
/*                                                                  */
/* - A be- es kimeneti formatum: s.12                               */
/* - Ez az implementacio az alabbi kozelitest hasznalja:            */
/*     sqrt(a.^2+b.^2)=max((0.875*max(a,b)+0.5*min(a,b)),max(a,b))  */
/*                                                                  */
/********************************************************************/

module abs(
	input signed [12:0] y_re, y_im,
	output signed [12:0] y_abs
);

	/* abszolutertek */
	wire signed [12:0] a, b;
	assign a=(y_re<0)?(-y_re):y_re;
	assign b=(y_im<0)?(-y_im):y_im;

	/* 0.875*max(a,b) */
	wire signed [12:0] m1;
	assign m1=(a>b)?(a-{3'b000,a[10:3]}):(b-{3'b000,b[10:3]});

	/* 0.5*min(a,b) */
	wire signed [12:0] m2;
	assign m2=(a<b)?{1'b0,a[12:1]}:{1'b0,b[12:1]};

	/* max(a,b) */
	wire signed [12:0] m3;
	assign m3=(a>b)?a:b;

	assign y_abs=((m1+m2)>m3)?(m1+m2):m3;

endmodule
