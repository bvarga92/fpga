#include "dma.h"
#include "xparameters.h"
#include "xaxidma.h"
#include "xscugic.h"

static XAxiDma AxiDma;
static void *ptr1, *ptr2;
static uint32_t rxBytes;
volatile void* rxBuffer;
volatile uint8_t dataAvailable=0;

void dmaInit(uint8_t* buf, uint32_t buf_size){
	XAxiDma_Config *CfgPtr;
	rxBuffer=buf;
	rxBytes=buf_size;
	CfgPtr=XAxiDma_LookupConfig(XPAR_AXIDMA_0_DEVICE_ID);
	XAxiDma_CfgInitialize(&AxiDma,CfgPtr);
	XAxiDma_IntrDisable(&AxiDma,XAXIDMA_IRQ_ALL_MASK,XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrDisable(&AxiDma,XAXIDMA_IRQ_ALL_MASK,XAXIDMA_DMA_TO_DEVICE);
	XAxiDma_Reset(&AxiDma);
}

void dmaReceive(){
	XAxiDma_SimpleTransfer(&AxiDma,(uintptr_t)rxBuffer,rxBytes,XAXIDMA_DEVICE_TO_DMA);
	while(XAxiDma_Busy(&AxiDma,XAXIDMA_DEVICE_TO_DMA)) ;
	Xil_DCacheInvalidateRange((uintptr_t)rxBuffer,rxBytes);
}

void RxIntrHandler(void* Callback){
	void* addr;
	uint32_t irqStatus;
	XAxiDma *AxiDmaInst=(XAxiDma*)Callback;
	irqStatus=XAxiDma_IntrGetIrq(AxiDmaInst,XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrAckIrq(AxiDmaInst,irqStatus,XAXIDMA_DEVICE_TO_DMA);
	if(!(irqStatus & XAXIDMA_IRQ_ALL_MASK)) return;
	if((irqStatus & XAXIDMA_IRQ_IOC_MASK)){
		dataAvailable=1;
		if(rxBuffer==ptr1){
			rxBuffer=ptr2;
			addr=ptr1;
		}
		else{
			rxBuffer=ptr1;
			addr=ptr2;
		}
		XAxiDma_SimpleTransfer(&AxiDmaInst,(uintptr_t)addr,rxBytes,XAXIDMA_DEVICE_TO_DMA);
	}
}

void dmaInitIT(uint8_t* buf, uint32_t transfer_size){
	XAxiDma_Config *CfgPtr;
	ptr1=buf;
	ptr2=buf+transfer_size;
	rxBuffer=ptr1;
	rxBytes=transfer_size;
	CfgPtr=XAxiDma_LookupConfig(XPAR_AXIDMA_0_DEVICE_ID);
	XAxiDma_CfgInitialize(&AxiDma,CfgPtr);
	XAxiDma_IntrDisable(&AxiDma,XAXIDMA_IRQ_ALL_MASK,XAXIDMA_DMA_TO_DEVICE);
	XAxiDma_IntrDisable(&AxiDma,XAXIDMA_IRQ_ALL_MASK,XAXIDMA_DEVICE_TO_DMA);
	XScuGic_RegisterHandler(XPAR_SCUGIC_0_CPU_BASEADDR,XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR,RxIntrHandler,&AxiDma);
	XScuGic_EnableIntr(XPAR_SCUGIC_0_DIST_BASEADDR,XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR);
	XAxiDma_IntrEnable(&AxiDma,XAXIDMA_IRQ_ALL_MASK,XAXIDMA_DEVICE_TO_DMA);
	dataAvailable=0;
	XAxiDma_SimpleTransfer(&AxiDma,(uintptr_t)ptr2,rxBytes,XAXIDMA_DEVICE_TO_DMA);
}
