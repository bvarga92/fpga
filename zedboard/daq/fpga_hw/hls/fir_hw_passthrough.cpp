#include "mytypes.h"

void fir_hw(ap_uint<16> tlast_dnum, din_t* input_l, din_t* input_r, out_stream_struct* res){
	#pragma HLS INTERFACE s_axilite port=tlast_dnum
	#pragma HLS INTERFACE ap_hs port=input_l
	#pragma HLS INTERFACE ap_hs port=input_r
	#pragma HLS INTERFACE axis port=res
	#pragma HLS INTERFACE ap_ctrl_none port=return

	out_stream_struct temp;
	static ap_uint<16> cntr=0;

	if(cntr%2==0){
		temp.tlast=(cntr>=tlast_dnum-1)?true:false;
		temp.tdata=*input_l;
		if(cntr>=tlast_dnum-1) cntr=0; else cntr++;
		*res=temp;
	}
	else{
		temp.tlast=(cntr>=tlast_dnum-1)?true:false;
		temp.tdata=*input_r;
		if(cntr>=tlast_dnum-1) cntr=0; else cntr++;
		*res=temp;
	}
}
