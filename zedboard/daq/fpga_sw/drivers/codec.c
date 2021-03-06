#include "codec.h"
#include "xparameters.h"
#include "xiic_l.h"

static void i2c_init(void){
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_RESETR_OFFSET,XIIC_RESET_MASK);
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_RFD_REG_OFFSET,0x0F);
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_CR_REG_OFFSET,XIIC_CR_TX_FIFO_RESET_MASK);
	XIic_WriteReg(XPAR_IIC_0_BASEADDR,XIIC_CR_REG_OFFSET,XIIC_CR_ENABLE_DEVICE_MASK);
}

static void i2c_write(uint16_t address, uint8_t data){
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

static uint8_t i2c_read(uint16_t address){
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

void codecInit(){
	i2c_init();
	i2c_write(0x4000,0x01);
	i2c_write(0x40F9,0xFF);
	i2c_write(0x40F9,0x7F);
	i2c_write(0x40FA,0x03);
	i2c_write(0x4015,0x09);
	i2c_write(0x4016,0x02);
	i2c_write(0x4017,0x06);
	i2c_write(0x40EB,0x00);
	i2c_write(0x40F8,0x06);
	i2c_write(0x400A,0x01);
	i2c_write(0x400B,0x05);
	i2c_write(0x400C,0x01);
	i2c_write(0x400D,0x05);
	i2c_write(0x401C,0x21);
	i2c_write(0x401E,0x41);
	i2c_write(0x4023,0xE7);
	i2c_write(0x4024,0xE7);
	i2c_write(0x4025,0xE7);
	i2c_write(0x4026,0xE7);
	i2c_write(0x4019,0x03);
	i2c_write(0x4029,0x03);
	i2c_write(0x402A,0x03);
	i2c_write(0x40F2,0x01);
	i2c_write(0x40F3,0x01);
	i2c_write(0x40FA,0x03);
}
