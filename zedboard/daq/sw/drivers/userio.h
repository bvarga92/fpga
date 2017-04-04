#ifndef _USERIO_H_
#define _USERIO_H_

	#include "xil_types.h"

	/* az atadott erteknek megfeleloen allitja be a LED-eket */
	void setLED(uint8_t val);
	
	/* visszaadja a 8 kapcsolo allapotat */
	uint8_t getSW(void);
	
	/* visszaadja az 5 nyomogomb allapotat */
	uint8_t getBTN(void);

#endif
