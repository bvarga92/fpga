#include "ap_int.h"
#include "ap_fixed.h"

typedef ap_fixed<24,1> data_t;
typedef ap_fixed<32,1> coeff_t;
typedef ap_fixed<65,11> accu_t;

void fir_hw(ap_uint<9> tap_num, coeff_t coeffs[512], data_t* in, data_t* out){
	#pragma HLS INTERFACE s_axilite port=tap_num
	#pragma HLS INTERFACE s_axilite port=coeffs
	#pragma HLS INTERFACE ap_hs port=in
	#pragma HLS INTERFACE ap_hs port=out
	#pragma HLS INTERFACE ap_ctrl_none port=return

	static data_t buf[512];
	static ap_uint<9> i=0;
	ap_uint<10> j, ix;
	accu_t accu;

	accu=0;
	ix=i;
	buf[i]=*in;
	MAC_LOOP_L: for(j=0;j<tap_num;j++){
		#pragma HLS LOOP_TRIPCOUNT min=1 max=512
		#pragma HLS PIPELINE II=1
		accu+=coeffs[j]*buf[ix++%tap_num];
	}
	if(i==0) i=tap_num-1; else i--;
	*out=accu;
}
