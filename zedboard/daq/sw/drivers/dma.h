#ifndef _DMA_H_
#define _DMA_H_

	#include "xil_types.h"

	/* DMA atvitel elkeszultet jelzo flag */
	extern volatile uint8_t dataAvailable;

	/* ha dataAvailable==1, akkor errol a cimrol olvashato ki az adat */
	extern volatile void* rxBuffer;


	/* DMA inicializalasa egyszeru modban */
	void dmaInit(uint8_t* buf, uint32_t buf_size);

	/* egy egyszeru vetel a dmaInit fuggvenyben megadott bufferbe */
	void dmaReceive(void);

	/* inicializalas megszakitasos modban, kettos bufferelessel (buffer merete >= 2*transfer_size) */
	void dmaInitIT(uint8_t* buf, uint32_t transfer_size);

#endif
