#include "xparameters.h"
#include "xgpio.h"
#include "xtime_l.h"

XTime time;
XGpio gpio_leds;

int main(void){
	XGpio_Initialize(&gpio_leds,XPAR_AXI_GPIO_0_DEVICE_ID);
	XGpio_SetDataDirection(&gpio_leds,1,0x00);
	while(1){
		XTime_GetTime(&time);
		XGpio_DiscreteWrite(&gpio_leds,1,(time/COUNTS_PER_SECOND)&0xFF);
	}
	return 0;
}
