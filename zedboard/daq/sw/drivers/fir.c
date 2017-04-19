#include "fir.h"
#include "xparameters.h"
#include "xfir_hw_hw.h"
#include "xil_io.h"

void firSetTLAST(uint16_t tlast_dnum){
	Xil_Out32(XPAR_XFIR_HW_0_S_AXI_AXILITES_BASEADDR+XFIR_HW_AXILITES_ADDR_TLAST_DNUM_V_DATA,tlast_dnum);
}

void firSetCoeffs(uint16_t tap_num, const int32_t* coeffs){
	uint16_t i;
	for(i=0;i<tap_num;i++) Xil_Out32(XPAR_XFIR_HW_0_S_AXI_AXILITES_BASEADDR+XFIR_HW_AXILITES_ADDR_COEFF_HW_V_BASE+(i<<2),coeffs[i]);
	Xil_Out32(XPAR_XFIR_HW_0_S_AXI_AXILITES_BASEADDR+XFIR_HW_AXILITES_ADDR_TAP_NUM_M1_V_DATA,tap_num-1);
}

void firSetDecimationFactor(uint8_t dec){
	Xil_Out32(XPAR_XFIR_HW_0_S_AXI_AXILITES_BASEADDR+XFIR_HW_AXILITES_ADDR_SMPL_RD_NUM_V_DATA,dec);
}
