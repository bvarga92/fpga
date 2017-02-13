#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdint.h>
#include <sys/mman.h>

static volatile uint32_t *led, *sw, *btn;

void init(void){
	int fd=open("/dev/mem",O_RDWR|O_SYNC);
	if(fd<0){
		printf("Error opening /dev/mem.\n\n");
		exit(1);
	}	
	led=mmap(0,getpagesize(),PROT_READ|PROT_WRITE,MAP_SHARED,fd,0x41200000);
	if(led==MAP_FAILED){
		printf("Memory mapping failed (led).\n\n");
		exit(1);
	}
	sw=mmap(0,getpagesize(),PROT_READ|PROT_WRITE,MAP_SHARED,fd,0x41210000);
	if(sw==MAP_FAILED){
		printf("Memory mapping failed (sw).\n\n");
		exit(1);
	}
	btn=mmap(0,getpagesize(),PROT_READ|PROT_WRITE,MAP_SHARED,fd,0x41220000);
	if(btn==MAP_FAILED){
		printf("Memory mapping failed (btn).\n\n");
		exit(1);
	}
}

void write_led(uint32_t value){
	*led=value&0xFF;
}

uint8_t read_sw(void){
	return (uint8_t)((*sw)&0xFF);
}

uint8_t read_btn(void){
	return (uint8_t)((*btn)&0xFF);
}

int main(int argc, char** argv){
	init();
	if((argc==2)&&(!strcmp(argv[1],"sw")))
		printf("%d\n\n",read_sw());
	else if((argc==2)&&(!strcmp(argv[1],"btn")))
		printf("%d\n\n",read_btn());
	else if((argc==3)&&(!strcmp(argv[1],"led")))
		write_led(strtol(argv[2],NULL,10));
	else
		printf("Usage: \"gpio sw\" or \"gpio btn\" or \"gpio led value\".\n\n");
	return 0;
}

