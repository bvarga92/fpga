#include "xparameters.h"
#include "xil_io.h"

void ledInit(void){
	Xil_Out32(XPAR_AXI_GPIO_LED_BASEADDR+4,0); //2 zold LED kimenet
	Xil_Out32(XPAR_AXI_GPIO_LED_BASEADDR+12,0); //RGB LED kimenet
	Xil_Out32(XPAR_AXI_GPIO_LED_BASEADDR,0); //zoldek kikapcs
	Xil_Out32(XPAR_AXI_GPIO_LED_BASEADDR+8,7); //RGB kikapcs
}

void ledSet(uint8_t greenLeds, uint8_t rgbLeds){
	Xil_Out32(XPAR_AXI_GPIO_LED_BASEADDR,greenLeds);
	Xil_Out32(XPAR_AXI_GPIO_LED_BASEADDR+8,~rgbLeds);
}

int main(void){
	volatile uint32_t i;
	uint8_t green=0, rgb=0;
	ledInit();
	while(1){
		for(i=0;i<100000;i++) ;
		ledSet(green,rgb);
		green=(green==3)?0:(green+1);
		rgb=(rgb==7)?0:(rgb+1);
	}
	return 0;
}
