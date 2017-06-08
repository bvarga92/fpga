#include "fir.h"
#include "xparameters.h"
#include "xfir_hw_hw.h"
#include "xil_io.h"

void firSetCoeffsL(uint16_t tap_num, const int32_t* coeffs){
	uint16_t i;
	for(i=0;i<tap_num;i++) Xil_Out32(XPAR_FIR_L_S_AXI_AXILITES_BASEADDR+XFIR_HW_AXILITES_ADDR_COEFFS_V_BASE+(i<<2),coeffs[i]);
	Xil_Out32(XPAR_FIR_L_S_AXI_AXILITES_BASEADDR+XFIR_HW_AXILITES_ADDR_TAP_NUM_V_DATA,tap_num);
}

void firSetCoeffsR(uint16_t tap_num, const int32_t* coeffs){
	uint16_t i;
	for(i=0;i<tap_num;i++) Xil_Out32(XPAR_FIR_R_S_AXI_AXILITES_BASEADDR+XFIR_HW_AXILITES_ADDR_COEFFS_V_BASE+(i<<2),coeffs[i]);
	Xil_Out32(XPAR_FIR_R_S_AXI_AXILITES_BASEADDR+XFIR_HW_AXILITES_ADDR_TAP_NUM_V_DATA,tap_num);
}
