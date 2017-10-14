#include "userio.h"
#include "camera.h"
#include "imgproc.h"

int main(void){
	camInit();
	imgprocDisable();
	setLED(0);
	while(1){
		if(getBTN()&0x10){ //felfele gomb
			imgprocEnable();
			setLED(255);
		}
		else if(getBTN()&0x02){ //lefele gomb
			imgprocDisable();
			setLED(0);
		}
	}
	return 1;
}
