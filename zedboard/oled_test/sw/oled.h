#ifndef _OLED_H_
#define _OLED_H_

	#include "xil_types.h"

	#define PIN_RES   54
	#define PIN_DC    55
	#define PIN_VBAT  56
	#define PIN_VDD   57

	extern uint8_t oledFrameBuffer[512];

	void oledInit(void);
	void oledPowerOff(void);
	void oledUpdate(void);
	void oledClear(void);
	void oledSetPixel(uint8_t x, uint8_t y);
	void oledClearPixel(uint8_t x, uint8_t y);
	void oledInvert(void);
	void oledSetCursor(uint8_t x, uint8_t y);
	void oledPrintChar(char ch);
	void oledPrintText(char *str);
	void oledDrawLine(uint8_t x1, uint8_t y1, uint8_t x2, uint8_t y2);
	void oledDrawCircle(uint8_t cx, uint8_t cy, uint8_t r);
	void oledDrawFilledCircle(uint8_t cx, uint8_t cy, uint8_t r);
	void oledDrawRectangle(uint8_t x, uint8_t y, uint8_t w, uint8_t h);
	void oledDrawFilledRectangle(uint8_t x, uint8_t y, uint8_t w, uint8_t h);

#endif
