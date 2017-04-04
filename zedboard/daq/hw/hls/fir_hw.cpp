#include "ap_int.h"
#include "ap_fixed.h"

typedef ap_fixed<24,1> din_t;

typedef struct{
	ap_fixed<32,1> tdata;
	bool tlast;
} out_stream_struct;


void fir_hw(ap_uint<16> tlast_dnum, din_t* input_l, din_t* input_r, out_stream_struct* res){
	#pragma HLS INTERFACE s_axilite port=tlast_dnum
	#pragma HLS INTERFACE ap_hs port=input_l
	#pragma HLS INTERFACE ap_hs port=input_r
	#pragma HLS INTERFACE axis register port=res
	#pragma HLS INTERFACE ap_ctrl_none port=return

	out_stream_struct temp;
	static unsigned cntr=0;

	temp.tlast=(cntr>=tlast_dnum-1)?true:false;
	temp.tdata=(cntr&0x01)?(*input_l):(*input_r);
	cntr=(cntr>=tlast_dnum-1)?0:(cntr+1);
	*res=temp;
}
