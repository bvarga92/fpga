#include "rgb_btn.h"
#include "xparameters.h"
#include "xgpio.h"

static XGpio gpio_rgb, gpio_btn;

void rgbInit(void){
	XGpio_Initialize(&gpio_rgb,XPAR_AXI_GPIO_RGB_DEVICE_ID);
	XGpio_SetDataDirection(&gpio_rgb,1,0x00);
}

void btnInit(void){
	XGpio_Initialize(&gpio_btn,XPAR_AXI_GPIO_BTN_DEVICE_ID);
	XGpio_SetDataDirection(&gpio_btn,1,0x03);
}

void rgbOut(uint8_t ld0_bgr, uint8_t ld1_bgr){
	XGpio_DiscreteWrite(&gpio_rgb,1,(ld1_bgr<<3)|ld0_bgr);
}

uint8_t btnIn(void){
	return XGpio_DiscreteRead(&gpio_btn,1);
}
