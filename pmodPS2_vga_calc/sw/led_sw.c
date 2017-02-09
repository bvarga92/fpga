#include <xparameters.h>
#include "led_sw.h"

void setLED(ubyte led){
	*(volatile uint32_t*)(XPAR_LED_SW_0_BASEADDR)=led;
}

ubyte getSW(){
	return *(volatile ubyte*)(XPAR_LED_SW_0_BASEADDR+4);
}
