#include "rgb_btn.h"
#include "xtime_l.h"

int main(void){
	uint8_t color=0, btn;
	XTime t1, t2;
	rgbInit();
	btnInit();
	XTime_GetTime(&t1);
	t2=t1;
	while(1){
		color=(color+1)%8;
		btn=btnIn();
		rgbOut(color*(btn&1), color*((btn&2)>>1));
		while(t1-t2 < COUNTS_PER_SECOND/10){
			XTime_GetTime(&t1);
		}
		t2=t1;
	}
	return 0;
}
