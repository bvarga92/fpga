#ifndef _FIR_H_
#define _FIR_H_

	#include "xil_types.h"

	/* beallitja a csomagmeretet */
	void firSetTLAST(uint16_t tlast_dnum);
	
	/* beallitja a FIR szuro egyutthatokeszletet */
	void firSetCoeffs(uint16_t tap_num, const int32_t* coeffs);

	/* beallitja a decimalasi tenyezot */
	void firSetDecimationFactor(uint8_t dec);

#endif
