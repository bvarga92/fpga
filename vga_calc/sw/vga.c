#include <xparameters.h>
#include "vga.h"
#include "font.h"

void vgaSetPixel(ubyte x, ubyte y, color_t color){
	if((y>=ROWS)||(x>=COLS)) return;
	*(volatile uint32_t*)(XPAR_VGA_0_BASEADDR|(y<<7)|x)=(ubyte)color;
}

void vgaClearScreen(color_t color){
	ubyte x, y;
	for(y=0;y<ROWS;y++) for(x=0;x<COLS;x++) vgaSetPixel(x,y,color);
}

void vgaDrawLine(ubyte x1, ubyte y1, ubyte x2, ubyte y2, color_t color){
	int16_t dx, dy, incx, incy, incx_parallel, incy_parallel, e1, e2, err, x, y, i;
	if((x1>=COLS)||(y1>=ROWS)||(x2>=COLS)||(y2>=ROWS)) return;
	dx=x2-x1;
	dy=y2-y1;
	incx=(dx>0)?1:((dx<0)?-1:0);
	incy=(dy>0)?1:((dy<0)?-1:0);
	if(dx<0) dx=-dx;
	if(dy<0) dy=-dy;
	if(dx>dy){
		incx_parallel=incx;
		incy_parallel=0;
		e1=dy;
		e2=dx;
	}
	else{
		incx_parallel=0;
		incy_parallel=incy;
		e1=dx;
		e2=dy;
	}
	x=x1;
	y=y1;
	err=e2>>1;
	vgaSetPixel(x,y,color);
	for(i=0;i<e2;i++){
		err-=e1;
		if(err<0){
			err+=e2;
			x+=incx;
			y+=incy;
		}
		else{
			x+=incx_parallel;
			y+=incy_parallel;
		}
		vgaSetPixel(x,y,color);
	}
}

void vgaPutChar(char c, ubyte x, ubyte y, color_t chcolor, color_t bgcolor){
	ubyte i, j;
	for(i=0;i<8;i++)
		for(j=0;j<8;j++)
			vgaSetPixel(x+j,y+i,(fontData[((c-32)<<3)+i] & (128>>j))?chcolor:bgcolor);
}

void vgaPrint(char *str, ubyte x, ubyte y, color_t chcolor, color_t bgcolor){
	ubyte i=0;
	while(str[i]){
		vgaPutChar(str[i],x,y,chcolor,bgcolor);
		i++;
		x+=8;
	}
}

void vgaPrintInt(int32_t n, ubyte x, ubyte y, color_t chcolor, color_t bgcolor){
	ubyte i, digits=0, d[10];
	if(n==0){
		vgaPutChar('0',x,y,chcolor,bgcolor);
		return;
	}
	if(n<0){
		vgaPutChar('-',x,y,chcolor,bgcolor);
		n=-n;
		x+=8;
	}
	for(i=0;i<10;i++){
		if(n==0) break;
		d[i]=n%10;
		n/=10;
		digits++;
	}
	for(i=digits;i;i--){
		vgaPutChar(d[i-1]+0x30,x,y,chcolor,bgcolor);
		x+=8;
	}
}
