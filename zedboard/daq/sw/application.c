#include "lwip/err.h"
#include "lwip/udp.h"
#include "xil_printf.h"
#include "drivers/userio.h"
#include "drivers/codec.h"
#include "drivers/dma.h"
#include "drivers/fir.h"
#include "xil_cache.h"

#define PORT   1234
#define N      1024

uint8_t daqFlag=0;
struct udp_pcb *daqPCB;
ip_addr_t daqIP;
uint16_t daqPort;
uint8_t buffer[N<<1];
uint8_t sw;

int transfer_data(){
	struct pbuf *p;
	if((!daqFlag)||(!dataAvailable)) return 0;
	dataAvailable=0;
	p=pbuf_alloc(PBUF_TRANSPORT,N,PBUF_REF);
	p->payload=(void*)rxBuffer;
	Xil_DCacheInvalidateRange((uintptr_t)rxBuffer,N);
	udp_sendto(daqPCB,p,&daqIP,daqPort);
	pbuf_free(p);
	return 0;
}

void print_app_header(){
	xil_printf("\n\r\n\r---------- ETHERNET AUDIO DAQ ----------\n\r");
}

void recv_callback(void *arg, struct udp_pcb *pcb, struct pbuf *p, ip_addr_t *addr, uint16_t port){
	uint8_t b=*((uint8_t*)(p->payload));
	if(b==0x00){
		daqFlag=1;
		daqPCB=pcb;
		daqIP=*addr;
		daqPort=port;
		xil_printf("Data acquisition started.\n\r");
	}
	else if(b==0x01){
		daqFlag=0;
		xil_printf("Data acquisition stopped.\n\r");
	}
	pbuf_free(p);
}

int start_application(){
	struct udp_pcb *pcb;
	setLED(0xFF);
	pcb=udp_new();
	if(!pcb){
		xil_printf("Error creating UDP protocol control block.\n\r");
		return 1;
	}
	if(udp_bind(pcb,IP_ADDR_ANY,PORT)!=ERR_OK){
		xil_printf("Unable to bind to port %d.\n\r",PORT);
		return 1;
	}
	udp_recv(pcb,recv_callback,NULL);
	xil_printf("UDP server started at port %d.\n\r",PORT);
	dmaInitIT(buffer,N);
	firSetTLAST(N>>2);
	codecInit();
	xil_printf("Hardware initialization complete.\n\r");
	setLED(0);
	return 0;
}
