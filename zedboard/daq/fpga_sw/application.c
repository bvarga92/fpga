#include "lwip/err.h"
#include "lwip/udp.h"
#include "xil_printf.h"
#include "drivers/userio.h"
#include "drivers/codec.h"
#include "drivers/dma.h"
#include "drivers/fir.h"
#include "drivers/fir_coeffs.h"
#include "xil_cache.h"

#define PORT   1234
#define N      1024

static uint8_t daqFlag=0;
static struct udp_pcb *daqPCB;
static ip_addr_t daqIP;
static uint16_t daqPort;
static uint8_t buffer[N*2];
static uint8_t sw;

static void configFilter(uint8_t c){
	uint8_t ledH=getLED()&0xF8;
	switch(c){
		case 1:  firSetCoeffs(256,coeffs256); firSetDecimationFactor(2); setLED(ledH|1); break;
		case 2:  firSetCoeffs(512,coeffs512); firSetDecimationFactor(4); setLED(ledH|2); break;
		default: firSetCoeffs(128,coeffs128); firSetDecimationFactor(1); setLED(ledH); break;
	}
}

void transfer_data(){
	struct pbuf *p;
	uint8_t sw2;
	if((!daqFlag)||(!dataAvailable)) return;
	dataAvailable=0;
	p=pbuf_alloc(PBUF_TRANSPORT,N,PBUF_REF);
	p->payload=(void*)rxBuffer;
	Xil_DCacheInvalidateRange((uintptr_t)rxBuffer,N);
	udp_sendto(daqPCB,p,&daqIP,daqPort);
	pbuf_free(p);
	sw2=getSW()&0x03;
	if(sw!=sw2){
		sw=sw2;
		configFilter(sw);
	}
}

void print_app_header(){
	xil_printf("\n\r\n\r---------- ETHERNET AUDIO DAQ ----------\n\r");
}

static void recv_callback(void *arg, struct udp_pcb *pcb, struct pbuf *p, ip_addr_t *addr, uint16_t port){
	uint8_t b=*((uint8_t*)(p->payload));
	if(b==0x00){
		daqFlag=1;
		daqPCB=pcb;
		daqIP=*addr;
		daqPort=port;
		xil_printf("Data acquisition started.\n\r");
		setLED(getLED()|0x80);
	}
	else if(b==0x01){
		daqFlag=0;
		xil_printf("Data acquisition stopped.\n\r");
		setLED(getLED()&0x7F);
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
	setLED(0);
	firSetTLAST(N>>2);
	sw=getSW()&0x03;
	configFilter(sw);
	codecInit();
	xil_printf("Hardware initialization complete.\n\r");
	return 0;
}
