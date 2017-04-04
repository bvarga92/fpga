#include "application.h"
#include "xparameters.h"
#include "netif/xadapter.h"
#include "platform.h"
#include "xil_printf.h"
#include "lwip/tcp.h"

void lwip_init(void);
void tcp_fasttmr(void);
void tcp_slowtmr(void);

int main(){
	struct netif server_netif;
	struct ip_addr ipaddr, netmask, gw;
	uint8_t mac[6]={0x00,0x0a,0x35,0x00,0x01,0x02};
	init_platform();
	IP4_ADDR(&ipaddr,  192, 168,   1, 155);
	IP4_ADDR(&netmask, 255, 255, 255,   0);
	IP4_ADDR(&gw,      192, 168,   1,   1);
	print_app_header();
	lwip_init();
	if(!xemac_add(&server_netif,&ipaddr,&netmask,&gw,mac,XPAR_XEMACPS_0_BASEADDR)){
		xil_printf("Error adding network interface!\n\r");
		return -1;
	}
	netif_set_default(&server_netif);
	platform_enable_interrupts();
	netif_set_up(&server_netif);
	xil_printf("Board IP: %d.%d.%d.%d\n\r",ip4_addr1(&ipaddr),ip4_addr2(&ipaddr),ip4_addr3(&ipaddr),ip4_addr4(&ipaddr));
	xil_printf("Netmask: %d.%d.%d.%d\n\r",ip4_addr1(&netmask),ip4_addr2(&netmask),ip4_addr3(&netmask),ip4_addr4(&netmask));
	xil_printf("Gateway: %d.%d.%d.%d\n\r",ip4_addr1(&gw),ip4_addr2(&gw),ip4_addr3(&gw),ip4_addr4(&gw));
	start_application();
	while(1){
		if(TcpFastTmrFlag){
			tcp_fasttmr();
			TcpFastTmrFlag=0;
		}
		if(TcpSlowTmrFlag){
			tcp_slowtmr();
			TcpSlowTmrFlag=0;
		}
		if(ResetRxFlag){
			xemacpsif_resetrx_on_no_rxdata(&server_netif);
			ResetRxFlag=0;
		}
		xemacif_input(&server_netif);
		transfer_data();
	}
	cleanup_platform();
	return 0;
}
