#include <stdio.h>
#include <stdint.h>

#define _N_        624
#define _M_        397
#define UPPER_MASK 0x80000000UL
#define LOWER_MASK 0x7FFFFFFFUL
#define _A_        0x9908B0DFUL
#define _U_        11
#define _S_        7
#define _B_        0x9D2C5680UL
#define _T_        15
#define _C_        0xEFC60000UL
#define _L_        18
#define _F_        1812433253UL

typedef struct{
	uint32_t mt[_N_];
	uint32_t idx;
} rng_t;

void seed(rng_t *rng, uint32_t s){
	rng->mt[0]=s;
	for(rng->idx=1;rng->idx<_N_;rng->idx++) rng->mt[rng->idx]=((uint64_t)(rng->mt[rng->idx-1]^(rng->mt[rng->idx-1]>>30))*_F_+rng->idx)&0xFFFFFFFFUL;
}

uint32_t getNext(rng_t *rng){
	uint32_t x, i;
	if(rng->idx>=_N_){
		for(i=0;i<_N_;i++){
			x=(rng->mt[i]&UPPER_MASK)|(rng->mt[(i+1)%_N_]&LOWER_MASK);
			rng->mt[i]=rng->mt[(i+_M_)%_N_]^((x&1)?((x>>1)^_A_):(x>>1));
		}
		rng->idx=0;
	}
	x=rng->mt[rng->idx];
	x^=(x>>_U_);
	x^=(x<<_S_)&_B_;
	x^=(x<<_T_)&_C_;
	x^=(x>>_L_);
	rng->idx++;
	return x;
}

int main(){
	rng_t rng;
	uint32_t i;
	seed(&rng,5489);
	for(i=1;i<=100;i++) printf("%3u: %10u\n",i,getNext(&rng));
	return 0;
}
