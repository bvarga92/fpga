#include "userio.h"
#include "oled.h"
#include <stdio.h>

void printSW(uint8_t sw){
	char str[4];
	uint8_t len;
	setLED(sw);
	oledSetCursor(62,24);
	oledPrintText(" ");
	oledSetCursor(58,24);
	oledPrintText("  ");
	oledSetCursor(55,24);
	oledPrintText("   ");
	len=sprintf(str,"%d",sw);
	str[len]=0;
	switch(len){
		case 1: oledSetCursor(62,24); break;
		case 2: oledSetCursor(58,24); break;
		case 3: oledSetCursor(55,24); break;
	}
	oledPrintText(str);
	oledUpdate();
}

int main(void){
	uint8_t sw, sw_prev;
	oledInit();
	oledSetCursor(48,0);
	oledPrintText("HELLO");
	oledDrawLine(0,0,127,31);
	oledDrawLine(127,0,0,31);
	oledDrawFilledCircle(20,16,5);
	oledDrawFilledCircle(107,16,5);
	oledUpdate();
	sw=sw_prev=getSW();
	printSW(sw);
	while(1){
		if(getBTN()==1) oledPowerOff();
		sw=getSW();
		if(sw!=sw_prev){
			printSW(sw);
			sw_prev=sw;
		}
	}
	return 1;
}
