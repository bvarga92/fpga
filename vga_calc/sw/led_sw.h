#ifndef _LED_SW_H_
#define _LED_SW_H_

	#include <mblaze_nt_types.h>

	/* beallitja a LED-eket */
	void setLED(ubyte led);

	/* beolvassa a kapcsolokat */
	ubyte getSW(void);

#endif
