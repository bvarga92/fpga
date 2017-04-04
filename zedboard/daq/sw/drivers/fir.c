#include "fir.h"
#include "xparameters.h"
#include "xfir_hw_hw.h"
#include "xil_io.h"

void firSetTLAST(uint16_t tlast_dnum){
	Xil_Out32(XPAR_XFIR_HW_0_S_AXI_AXILITES_BASEADDR+XFIR_HW_AXILITES_ADDR_TLAST_DNUM_V_DATA,tlast_dnum);
}
