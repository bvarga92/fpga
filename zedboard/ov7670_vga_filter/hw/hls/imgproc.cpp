#include "ap_int.h"
#include "ap_fixed.h"

typedef ap_fixed<10,5> coeff_t;
typedef ap_fixed<18,12> accu_t;
typedef struct{
	ap_uint<19> addr;
	ap_uint<12> data; //rrrrggggbbbb
} data_t;

//const coeff_t filter[9]={0.1111f,0.1111f,0.1111f,0.1111f,0.1111f,0.1111f,0.1111f,0.1111f,0.1111f};
//const coeff_t filter[9]={-2,-1,0-1,1,1,0,1,2};
//const coeff_t filter[9]={-1,-1,-1,-1,9,-1,-1,-1,-1};
const coeff_t filter[9]={1,2,1,0,0,0,-1,-2,-1};

void imgproc(data_t *in, data_t *out, bool enable){
	/* portok */
	#pragma HLS INTERFACE ap_vld port=in
	#pragma HLS INTERFACE ap_ovld port=out
	#pragma HLS INTERFACE s_axilite port=enable
	#pragma HLS INTERFACE ap_ctrl_none port=return
	/* valtozok */
	static ap_uint<12> buffer[3][640], p;
	static ap_uint<10> col=345;
	static ap_uint<2> row=0;
	ap_uint<4> r, g, b;
	coeff_t f;
	accu_t accR=0, accG=0, accB=0;
	data_t temp;
	#pragma HLS ARRAY_PARTITION variable=buffer complete
	#pragma HLS ARRAY_PARTITION variable=filter complete
	/* feldolgozas */
	buffer[row][col]=in->data;
	if(col<638){
		CONV1: for(int i=0;i<3;i++){
		#pragma HLS UNROLL
			CONV2: for(int j=0;j<3;j++){
			#pragma HLS UNROLL
				p=buffer[(row+j)%3][col+i];
				f=filter[j*3+i];
				r=p>>8;
				g=(p>>4)&0xF;
				b=p&0xF;
				accR+=f*r;
				accG+=f*g;
				accB+=f*b;
			}
		}
		if(accR<0) accR=0; else if(accR>15) accR=15;
		if(accG<0) accG=0; else if(accG>15) accG=15;
		if(accB<0) accB=0; else if(accB>15) accB=15;
	}
	p=(((ap_uint<12>)accR)<<8)|(((ap_uint<12>)accG)<<4)|((ap_uint<12>)accB);
	col++;
	if(col==640){
		col=0;
		row=(row+1)%3;
	}
	/* adatkiadas */
	temp.addr=in->addr;
	temp.data=enable?p:(in->data);
	*out=temp;
}
