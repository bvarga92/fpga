#include <linux/module.h>
#include <linux/printk.h>
#include <linux/ioport.h>
#include <asm/io.h>
#include <linux/timer.h>

#define ADDR 0x41200000

void *ledptr;
volatile unsigned char ledval;
static struct timer_list ledTimer;

void ledTimerCallback(unsigned long data){
	ledval=(ledval+1)&0xFF;
	iowrite32(ledval,ledptr);
	mod_timer(&ledTimer,jiffies+msecs_to_jiffies(1000));
}

int onLoad(void){
	ledval=0x01;
	request_mem_region(ADDR,16,"LEDs");
	ledptr=ioremap(ADDR,16);
	iowrite32(ledval,ledptr);
	setup_timer(&ledTimer,ledTimerCallback,0);
	mod_timer(&ledTimer,jiffies+msecs_to_jiffies(1000));
	printk(KERN_INFO "LED counter module loaded.\n");
	return 0;
}

void onUnload(void){
	del_timer(&ledTimer);
	iowrite32(0x00,ledptr);
	iounmap(ledptr);
	release_mem_region(ADDR,16);
	printk(KERN_INFO "LED counter module unloaded.\n");
}

module_init(onLoad);
module_exit(onUnload);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Balazs Varga");
MODULE_DESCRIPTION("LED counter");

