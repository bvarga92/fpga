#include "xparameters.h"
#include "xparameters_ps.h"
#include "xil_cache.h"
#include "xscugic.h"
#include "lwip/tcp.h"
#include "xil_printf.h"
#include "xscutimer.h"

#define RESET_RX_CNTR_LIMIT   400

void tcp_fasttmr(void);
void tcp_slowtmr(void);

static XScuTimer TimerInstance;
volatile uint8_t TcpFastTmrFlag=0;
volatile uint8_t TcpSlowTmrFlag=0;
volatile uint8_t ResetRxFlag=0;

void timer_callback(XScuTimer* TimerInstance){
	static uint8_t odd=1;
	static uint16_t ResetRxCntr=0;
	odd=!odd;
	TcpFastTmrFlag=1;
	if(odd) TcpSlowTmrFlag=1;
	ResetRxCntr++;
	if(ResetRxCntr>=RESET_RX_CNTR_LIMIT){
		ResetRxFlag=1;
		ResetRxCntr=0;
	}
	XScuTimer_ClearInterruptStatus(TimerInstance);
}

void platform_setup_timer(void){
	XScuTimer_Config *ConfigPtr;
	ConfigPtr=XScuTimer_LookupConfig(XPAR_SCUTIMER_DEVICE_ID);
	XScuTimer_CfgInitialize(&TimerInstance,ConfigPtr,ConfigPtr->BaseAddr);
	XScuTimer_SelfTest(&TimerInstance);
	XScuTimer_EnableAutoReload(&TimerInstance);
	XScuTimer_LoadTimer(&TimerInstance,XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ/8); //250 ms
}

void platform_setup_interrupts(void){
	Xil_ExceptionInit();
	XScuGic_DeviceInitialize(XPAR_SCUGIC_SINGLE_DEVICE_ID);
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,(Xil_ExceptionHandler)XScuGic_DeviceInterruptHandler,(void*)XPAR_SCUGIC_SINGLE_DEVICE_ID);
	XScuGic_RegisterHandler(XPAR_SCUGIC_0_CPU_BASEADDR,XPAR_SCUTIMER_INTR,(Xil_ExceptionHandler)timer_callback,(void*)&TimerInstance);
	XScuGic_EnableIntr(XPAR_SCUGIC_0_DIST_BASEADDR,XPAR_SCUTIMER_INTR);
}

void platform_enable_interrupts(){
	Xil_ExceptionEnableMask(XIL_EXCEPTION_IRQ);
	XScuTimer_EnableInterrupt(&TimerInstance);
	XScuTimer_Start(&TimerInstance);
}

void init_platform(){
	platform_setup_timer();
	platform_setup_interrupts();
}

void cleanup_platform(){
	Xil_ICacheDisable();
	Xil_DCacheDisable();
}
