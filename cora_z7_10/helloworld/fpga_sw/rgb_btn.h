#ifndef _RGB_BTN_H_
#define _RGB_BTN_H_

	#include "stdint.h"

	void rgbInit(void);
	void btnInit(void);
	void rgbOut(uint8_t ld0_bgr, uint8_t ld1_bgr);
	uint8_t btnIn(void);

#endif
