#ifndef _MYTYPES_H_
#define _MYTYPES_H_

	#include "ap_int.h"
	#include "ap_fixed.h"

	typedef ap_fixed<24,1> din_t;
	typedef ap_fixed<32,1> coeff_t;
	typedef ap_fixed<65,11> accu_t;

	typedef struct{
		ap_fixed<32,1> tdata;
		bool tlast;
	} out_stream_struct;

#endif
