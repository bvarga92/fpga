#include "imgproc.h"
#include "xparameters.h"
#include "ximgproc_hw.h"
#include "xil_io.h"

void imgprocEnable(void){
	Xil_Out32(XPAR_IMGPROC_0_S_AXI_AXILITES_BASEADDR+XIMGPROC_AXILITES_ADDR_ENABLE_DATA,1);
}

void imgprocDisable(void){
	Xil_Out32(XPAR_IMGPROC_0_S_AXI_AXILITES_BASEADDR+XIMGPROC_AXILITES_ADDR_ENABLE_DATA,0);
}
