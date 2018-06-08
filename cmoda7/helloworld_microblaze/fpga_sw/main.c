#include "xparameters.h"
#include "xil_io.h"

int main(void){
	uint32_t i=0;
	uint8_t rgb=0, btn;
	while(1){
		i++;
		if(i==100000){
			i=0;
			rgb=(rgb==7)?0:(rgb+1);
			Xil_Out32(XPAR_AXI_GPIO_LED_BASEADDR+8,~rgb);
		}
		btn=Xil_In8(XPAR_AXI_GPIO_BTN_BASEADDR);
		Xil_Out32(XPAR_AXI_GPIO_LED_BASEADDR,(btn<<1)|btn);
	}
	return 0;
}
