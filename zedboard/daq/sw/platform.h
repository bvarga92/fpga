#ifndef __PLATFORM_H_
#define __PLATFORM_H_

	#include "xil_types.h"

	extern volatile uint8_t TcpFastTmrFlag;
	extern volatile uint8_t TcpSlowTmrFlag;
	extern volatile uint8_t ResetRxFlag;

	void platform_enable_interrupts(void);
	void init_platform(void);
	void cleanup_platform(void);

#endif
