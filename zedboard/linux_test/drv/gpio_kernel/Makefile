obj-m += gpio_kernel.o

all:
	make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- -C /home/bvarga/petalinux/zedboard_linux/build/linux/kernel/xlnx-4.0/ M=$(shell pwd) modules

clean:
	make -C /home/bvarga/petalinux/zedboard_linux/build/linux/kernel/xlnx-4.0/ M=$(shell pwd) clean

