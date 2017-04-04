#include "userio.h"
#include "xparameters.h"
#include "xil_io.h"

void setLED(uint8_t val){
	Xil_Out32(XPAR_AXI_GPIO_LED_BASEADDR,val);
}

uint8_t getSW(void){
	return Xil_In32(XPAR_AXI_GPIO_SW_BASEADDR)&0xFF;
}

uint8_t getBTN(void){
	return Xil_In32(XPAR_AXI_GPIO_BTN_BASEADDR)&0xFF;
}
