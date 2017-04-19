#include "mytypes.h"

void fir_hw(ap_uint<16> tlast_dnum, ap_uint<3> smpl_rd_num, ap_uint<9> tap_num_m1, coeff_t coeff_hw[512], din_t* input_l, din_t* input_r, out_stream_struct* res){
	#pragma HLS INTERFACE s_axilite port=tlast_dnum
	#pragma HLS INTERFACE s_axilite port=smpl_rd_num
	#pragma HLS INTERFACE s_axilite port=tap_num_m1
	#pragma HLS INTERFACE s_axilite port=coeff_hw
	#pragma HLS INTERFACE ap_hs port=input_l
	#pragma HLS INTERFACE ap_hs port=input_r
	#pragma HLS INTERFACE axis port=res
	#pragma HLS INTERFACE ap_ctrl_none port=return

	static bool left_ch=false;
	static ap_uint<16> tlast_cntr=0;
	static ap_uint<3> dec_cntr_l=0, dec_cntr_r=0;
	static din_t bufL[512], bufR[512];
	static ap_uint<9> iL=0, iR=0;
	ap_uint<10> j, ixL, ixR;
	static accu_t accuL, accuR;
	out_stream_struct temp;

	if(left_ch){
		accuL=0;
		ixL=iL;
		bufL[iL]=*input_l;
		if(dec_cntr_l==0){
			MAC_LOOP_L: for(j=0;j<=tap_num_m1;j++){
				#pragma HLS LOOP_TRIPCOUNT min=1 max=512
				#pragma HLS PIPELINE II=1
				accuL+=coeff_hw[j]*bufL[ixL++%(tap_num_m1+1)];
			}
			temp.tdata=accuL;
			temp.tlast=(tlast_cntr>=tlast_dnum-1)?true:false;
			if(tlast_cntr>=tlast_dnum-1) tlast_cntr=0; else tlast_cntr++;
			*res=temp;
		}
		if(iL==0) iL=tap_num_m1; else iL--;
		dec_cntr_l=(dec_cntr_l+1)%smpl_rd_num;
	}
	else{
		accuR=0;
		ixR=iR;
		bufR[iR]=*input_r;
		if(dec_cntr_r==0){
			MAC_LOOP_R: for(j=0;j<=tap_num_m1;j++){
				#pragma HLS LOOP_TRIPCOUNT min=1 max=512
				#pragma HLS PIPELINE II=1
				accuR+=coeff_hw[j]*bufR[ixR++%(tap_num_m1+1)];
			}
			temp.tdata=accuR;
			temp.tlast=(tlast_cntr>=tlast_dnum-1)?true:false;
			if(tlast_cntr>=tlast_dnum-1) tlast_cntr=0; else tlast_cntr++;
			*res=temp;
		}
		if(iR==0) iR=tap_num_m1; else iR--;
		dec_cntr_r=(dec_cntr_r+1)%smpl_rd_num;
	}
	left_ch=!left_ch;
}
