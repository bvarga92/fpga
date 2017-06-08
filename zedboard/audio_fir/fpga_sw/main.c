#include "userio.h"
#include "codec.h"
#include "fir.h"

static const int32_t coeffs1[401]={
	#include "coeffs1_dirac.dat"
};
static const int32_t coeffs2[401]={
	#include "coeffs2_lowpass.dat"
};
static const int32_t coeffs3[401]={
	#include "coeffs3_highpass.dat"
};
static const int32_t coeffs4[401]={
	#include "coeffs4_bandpass.dat"
};
static const int32_t coeffs5[401]={
	#include "coeffs5_bandstop.dat"
};

void configFilter(uint8_t select){
	switch(select){
		case 1: setLED(1); firSetCoeffsL(401,coeffs1); firSetCoeffsR(401,coeffs1); break;
		case 2: setLED(2); firSetCoeffsL(401,coeffs2); firSetCoeffsR(401,coeffs2); break;
		case 3: setLED(3); firSetCoeffsL(401,coeffs3); firSetCoeffsR(401,coeffs3); break;
		case 4: setLED(4); firSetCoeffsL(401,coeffs4); firSetCoeffsR(401,coeffs4); break;
		case 5: setLED(5); firSetCoeffsL(401,coeffs5); firSetCoeffsR(401,coeffs5); break;
	}
}

int main(void){
	codecInit();
	configFilter(1);
	while(1){
		if(getBTN()==1)
			configFilter(1);
		else if(getBTN()==2)
			configFilter(2);
		else if(getBTN()==4)
			configFilter(3);
		else if(getBTN()==8)
			configFilter(4);
		else if(getBTN()==16)
			configFilter(5);
	}
	return 0;
}
