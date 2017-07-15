#include "camera.h"
#include "xparameters.h"
#include "xiic.h"
#include "xil_io.h"
#include "userio.h"

#define NUM_CONFIG_REGS 70

static XIic iic;

static const uint8_t configData[NUM_CONFIG_REGS][2]={
		{0x12,0x80},//COM7
		{0x12,0x80},//COM7
		{0x12,0x04},//COM7
		{0x11,0x00},//CLKRC
		{0x0C,0x00},//COM3
		{0x3E,0x00},//COM14
		{0x04,0x00},//COM1
		{0x40,0x30},//COM15
		{0x3A,0x00},//TSLB
		{0x4F,0x80},//MTX1
		{0x50,0x80},//MTX2
		{0x51,0x00},//MTX3
		{0x52,0x22},//MTX4
		{0x53,0x5E},//MTX5
		{0x54,0x80},//MTX6
		{0x58,0x9E},//MTXS
		{0x3D,0xC0},//COM13
		{0x17,0x13},//HSTRT
		{0x18,0x01},//HSTOP
		{0x32,0xB6},//HREF
		{0x19,0x02},//VSTRT
		{0x1A,0x7A},//VSTOP
		{0x03,0x0A},//VREF
		{0x0E,0x61},//COM5
		{0x0F,0x4B},//COM6
		{0x1E,0x37},//MVFP
		{0x21,0x02},//ADCCTR1
		{0x22,0x91},//ADCCTR2
		{0x33,0x0B},//CHLF
		{0x3C,0x78},//COM12
		{0x69,0x00},//GFIX
		{0x6B,0x4A},//DBLV
		{0x14,0x10},//COM9
		{0x01,0x40},//BLUE
		{0x02,0x40},//RED
		{0x6A,0x40},//GGAIN
		{0x41,0x08},//COM16
		{0x74,0x10},//REG74
		{0xB0,0x84},//Linux driverbol (nem dokumentalt)
		{0xB3,0x82},//THL_ST
		{0xB1,0x0C},//ABLC
		{0x13,0xE7},//COM8
		{0xC9,0x60},//SATCTR
		{0x00,0x00},//GAIN
		{0x24,0x95},//AEW
		{0x25,0x33},//AEB
		{0x26,0xE3},//VPT
		{0x9F,0x78},//HAECC1
		{0xA0,0x68},//HAECC2
		{0xA6,0xD8},//HAECC3
		{0xA7,0xD8},//HAECC4
		{0xA8,0xF0},//HAECC5
		{0xA9,0x90},//HAECC6
		{0xAA,0x94},//HAECC7
		{0x43,0x14},//AWBC1
		{0x44,0xf0},//AWBC2
		{0x45,0x34},//AWBC3
		{0x46,0x58},//AWBC4
		{0x47,0x28},//AWBC5
		{0x48,0x3a},//AWBC6
		{0x59,0x88},//AWBC7
		{0x5A,0x88},//AWBC8
		{0x5B,0x44},//AWBC9 
		{0x5C,0x67},//AWBC10
		{0x5D,0x49},//AWBC11
		{0x5E,0x0E},//AWBC12
		{0x6C,0x0A},//AWBCTR3
		{0x6D,0x55},//AWBCTR2
		{0x6E,0x11},//AWBCTR1 
		{0x6F,0x9F},//AWBCTR0
};

static void error(void){
	setLED(0x55);
	while(1) ;
}

static void camWriteReg(uint8_t addr, uint8_t data){
	uint8_t toSend[2]={addr,data};
	while(!(XIic_ReadReg(XPAR_AXI_IIC_0_BASEADDR,XIIC_SR_REG_OFFSET)&XIIC_SR_TX_FIFO_EMPTY_MASK)) ;
	while(XIic_ReadReg(XPAR_AXI_IIC_0_BASEADDR,XIIC_SR_REG_OFFSET)&XIIC_SR_BUS_BUSY_MASK) ;
	if(XIic_Send(XPAR_AXI_IIC_0_BASEADDR,0x21,toSend,2,XIIC_STOP)!=2) error();
}

static uint8_t camReadReg(uint8_t addr){
	uint8_t data;
	while(!(XIic_ReadReg(XPAR_AXI_IIC_0_BASEADDR,XIIC_SR_REG_OFFSET)&XIIC_SR_TX_FIFO_EMPTY_MASK)) ;
	while(XIic_ReadReg(XPAR_AXI_IIC_0_BASEADDR,XIIC_SR_REG_OFFSET)&XIIC_SR_BUS_BUSY_MASK) ;
	if(XIic_Send(XPAR_AXI_IIC_0_BASEADDR,0x21,&addr,1,XIIC_STOP)!=1) error();
	if(XIic_Recv(XPAR_AXI_IIC_0_BASEADDR,0x21,&data,1,XIIC_STOP)!=1) error();
	return data;
}

void camInit(void){
	uint8_t i;
	volatile uint32_t del;
	XIic_Config *configPtr;
	/* reset ki, power-up */
	for(del=0;del<1000000;del++) ;
	Xil_Out32(XPAR_AXI_GPIO_CAM_BASEADDR,2);
	for(del=0;del<1000000;del++) ;
	/* AXI IIC inicializalasa */
	configPtr=XIic_LookupConfig(XPAR_AXI_IIC_0_DEVICE_ID);
	XIic_CfgInitialize(&iic,configPtr,configPtr->BaseAddress);
	/* chip ID kiolvasasa */
	if(camReadReg(0x0A)!=0x76) error();
	/* regiszterek konfiguralasa */
	for(i=0;i<NUM_CONFIG_REGS;i++){
		camWriteReg(configData[i][0],configData[i][1]);
		for(del=0;del<500000;del++) ;
	}
}
