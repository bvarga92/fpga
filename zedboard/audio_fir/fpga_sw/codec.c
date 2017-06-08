#include "codec.h"
#include "xparameters.h"
#include "xiic_l.h"

static void i2cInit(void){
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_RESETR_OFFSET,XIIC_RESET_MASK);
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_RFD_REG_OFFSET,0x0F);
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_CR_REG_OFFSET,XIIC_CR_TX_FIFO_RESET_MASK);
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_CR_REG_OFFSET,XIIC_CR_ENABLE_DEVICE_MASK);
}

static void i2cWrite(uint16_t address, uint8_t data){
	while(!(XIic_ReadReg(XPAR_IIC_0_BASEADDR,XIIC_SR_REG_OFFSET)&XIIC_SR_RX_FIFO_EMPTY_MASK))
		XIic_ReadReg(XPAR_IIC_0_BASEADDR,XIIC_DRR_REG_OFFSET);
	while(!(XIic_ReadReg(XPAR_IIC_0_BASEADDR,XIIC_SR_REG_OFFSET)&XIIC_SR_TX_FIFO_EMPTY_MASK)) ;
	while(XIic_ReadReg(XPAR_IIC_0_BASEADDR,XIIC_SR_REG_OFFSET)&XIIC_SR_BUS_BUSY_MASK) ;
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_DTR_REG_OFFSET,0x170);
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_DTR_REG_OFFSET,(address>>8)&0xFF);
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_DTR_REG_OFFSET,address&0xFF);
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_DTR_REG_OFFSET,0x200|data);
	while(!(XIic_ReadReg(XPAR_IIC_0_BASEADDR,XIIC_SR_REG_OFFSET)&XIIC_SR_TX_FIFO_EMPTY_MASK)) ;
}

static uint8_t i2cRead(uint16_t address){
	while(!(XIic_ReadReg(XPAR_IIC_0_BASEADDR,XIIC_SR_REG_OFFSET)&XIIC_SR_RX_FIFO_EMPTY_MASK))
		XIic_ReadReg(XPAR_IIC_0_BASEADDR,XIIC_DRR_REG_OFFSET);
	while(!(XIic_ReadReg(XPAR_IIC_0_BASEADDR,XIIC_SR_REG_OFFSET)&XIIC_SR_TX_FIFO_EMPTY_MASK)) ;
	while(XIic_ReadReg(XPAR_IIC_0_BASEADDR,XIIC_SR_REG_OFFSET)&XIIC_SR_BUS_BUSY_MASK) ;
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_DTR_REG_OFFSET,0x170);
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_DTR_REG_OFFSET,(address>>8)&0xFF);
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_DTR_REG_OFFSET,address&0xFF);
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_DTR_REG_OFFSET,0x171);
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_DTR_REG_OFFSET,0x201);
	while(!(XIic_ReadReg(XPAR_IIC_0_BASEADDR,XIIC_SR_REG_OFFSET)&XIIC_SR_TX_FIFO_EMPTY_MASK)) ;
	while(XIic_ReadReg(XPAR_IIC_0_BASEADDR,XIIC_SR_REG_OFFSET)&XIIC_SR_RX_FIFO_EMPTY_MASK) ;
	return XIic_ReadReg(XPAR_IIC_0_BASEADDR,XIIC_DRR_REG_OFFSET)&0xFF;
}

static void codecWriteReg(uint16_t reg, uint8_t data){
	i2cWrite(reg,data);
	if(i2cRead(reg)!=data) while(1) ;
}

void codecInit(){
	i2cInit();
	codecWriteReg(0x4000,0x01);
	codecWriteReg(0x40F9,0xFF);
	codecWriteReg(0x40F9,0x7F);
	codecWriteReg(0x40FA,0x03);
	codecWriteReg(0x4015,0x09);
	codecWriteReg(0x4016,0x02);
	codecWriteReg(0x4017,0x06);
	codecWriteReg(0x40EB,0x00);
	codecWriteReg(0x40F8,0x06);
	codecWriteReg(0x400A,0x01);
	codecWriteReg(0x400B,0x05);
	codecWriteReg(0x400C,0x01);
	codecWriteReg(0x400D,0x05);
	codecWriteReg(0x401C,0x21);
	codecWriteReg(0x401E,0x41);
	codecWriteReg(0x4023,0xE7);
	codecWriteReg(0x4024,0xE7);
	codecWriteReg(0x4025,0xE7);
	codecWriteReg(0x4026,0xE7);
	codecWriteReg(0x4019,0x03);
	codecWriteReg(0x4029,0x03);
	codecWriteReg(0x402A,0x03);
	codecWriteReg(0x40F2,0x01);
	codecWriteReg(0x40F3,0x01);
	codecWriteReg(0x40FA,0x03);
}
