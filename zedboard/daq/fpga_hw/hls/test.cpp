#include <stdio.h>
#include <stdlib.h>
#include "mytypes.h"

#define N_COEFFS   256
#define N_SIM      300

extern void fir_hw(ap_uint<16> tlast_dnum, ap_uint<3> smpl_rd_num, ap_uint<9> tap_num_m1, coeff_t coeff_hw[512], din_t* input_l, din_t* input_r, out_stream_struct* res);

int main(){
	/* szuroegyutthatok beallitasa veletlenszeruen */
	coeff_t coeffs[N_COEFFS];
	for(unsigned i=0;i<N_COEFFS;i++) coeffs[i]=rand()/((float)RAND_MAX)*1.8-0.9;
	/* a FIR szuro mukodtetese impulzus bemenetre */
	din_t in;
	out_stream_struct res;
	float outR[N_SIM], outL[N_SIM];
	for(unsigned i=0;i<N_SIM;i++){
		/* jobb csatorna */
		in=(i==0)?0.5f:0.0f;
		fir_hw(256,1,N_COEFFS-1,coeffs,&in,&in,&res);
		outR[i]=(float)res.tdata;
		/* bal csatorna */
		in=(i==0)?0.25f:0.0f;
		fir_hw(256,1,N_COEFFS-1,coeffs,&in,&in,&res);
		outL[i]=(float)res.tdata;
	}
	/* ellenorzes */
	double max=0;
	for(unsigned i=0;i<N_COEFFS;i++){
		double errR=(double)outR[i]-0.50*(double)coeffs[i];
		double errL=(double)outL[i]-0.25*(double)coeffs[i];
		if(errR>max) max=errR;
		if(errL>max) max=errL;
		printf("\nerr. left: %+1.3e \t err. right: %+1.3e",errL,errR);
	}
	printf("\n\nMAX. ERR.: %.3e\n\n",max);
	return 0;
}
