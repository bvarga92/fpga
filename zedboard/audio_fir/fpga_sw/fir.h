#ifndef _FIR_H_
#define _FIR_H_

	#include "xil_types.h"

	/* beallitja a FIR szurok egyutthatokeszletet */
	void firSetCoeffsL(uint16_t tap_num, const int32_t* coeffs);
	void firSetCoeffsR(uint16_t tap_num, const int32_t* coeffs);

#endif
