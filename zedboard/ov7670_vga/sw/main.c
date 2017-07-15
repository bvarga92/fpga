#include "userio.h"
#include "camera.h"

int main(void){
	camInit();
	while(1){
		setLED(getSW());
	}
	return 1;
}
