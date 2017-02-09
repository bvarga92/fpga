#include <xparameters.h>
#include "ps2_keyboard.h"

ubyte kbIsEmpty(){
	ubyte status;
	status=*((volatile ubyte*)(XPAR_PS2_KEYBOARD_0_BASEADDR));
	return status&0x01;
}

ubyte kbIsFull(){
	ubyte status;
	status=*((volatile ubyte*)(XPAR_PS2_KEYBOARD_0_BASEADDR));
	return (status&0x02)?1:0;
}

int16_t kbGetChar(){
	ubyte ascii;
	static ubyte ascii_prev;
	if(kbIsEmpty()) return -1;
	ascii=*((volatile ubyte*)(XPAR_PS2_KEYBOARD_0_BASEADDR+4));
	if(ascii_prev==0xF0){
		ascii_prev=ascii;
		return ascii;
	}
	ascii_prev=ascii;
	return -1;
}
