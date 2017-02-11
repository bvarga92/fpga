#include "xparameters.h"
#include "xgpio.h"

XGpio gpio_leds;

int main(void){
	volatile unsigned i;
	unsigned led=0;
	XGpio_Initialize(&gpio_leds,XPAR_AXI_GPIO_0_DEVICE_ID);
	XGpio_SetDataDirection(&gpio_leds,1,0x00);
	while(1){
		XGpio_DiscreteWrite(&gpio_leds,1,led);
		led=(led==255)?0:(led+1);
		for(i=0;i<10000000;i++) ;
	}
	return 0;
}
