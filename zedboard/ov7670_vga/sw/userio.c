#include "userio.h"
#include "xparameters.h"
#include "xil_io.h"

static uint8_t ledval=0;

void setLED(uint8_t val){
	ledval=val;
	Xil_Out32(XPAR_AXI_GPIO_LED_BASEADDR,ledval);
}

uint8_t getLED(){
	return ledval;
}

uint8_t getSW(){
	return Xil_In32(XPAR_AXI_GPIO_SW_BASEADDR)&0xFF;
}

uint8_t getBTN(){
	return Xil_In32(XPAR_AXI_GPIO_BTN_BASEADDR)&0xFF;
}
