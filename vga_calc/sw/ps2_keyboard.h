#ifndef _PS2_KEYBOARD_H_
#define _PS2_KEYBOARD_H_

	#include <mblaze_nt_types.h>

	/* ures-e a veteli FIFO */
	ubyte kbIsEmpty(void);

	/* megtelt-e a veteli FIFO */
	ubyte kbIsFull(void);

	/* ha van ervenyes karakter a FIFO-ban (billentyut felengedtek),
	   akkor azzal ter vissza, kulonben -1-gyel                       */
	int16_t kbGetChar(void);

#endif
