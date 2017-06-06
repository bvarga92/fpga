/******************************************************************************************/
/*                                                                                        */
/* Az SD kartyarol egymas utan olvassuk be az img1.bmp, img2.bmp, img3.bmp... nevu        */
/* fajlokat, es 5-5 masodpercig megjelenitjuk oket. A kepek csak 32x32-es felbontasu,     */
/* 24 bpp szinmelysegu BMP fajlok lehetnek. A fajlneveknek pontosan stimmelniuk kell, a   */
/* szamozasnak folytonosnak kell lennie, es az elso kep nevenek mindenkeppen img1.bmp-nek */
/* kell lennie. Az also nyomogombbal ki-, a felsovel bekapcsolhatjuk a kijelzot.          */
/*                                                                                        */
/******************************************************************************************/


#include "xparameters.h"
#include "xgpio.h"
#include "xtmrctr.h"
#include "xscugic.h"
#include "xil_io.h"
#include "ff.h"
#include <stdio.h>
#include <stdlib.h>


/* globalis valtozok */
static XGpio gpioLED, gpioSW, gpioBTN;
volatile uint8_t drawNext=1, displayEnabled=1;


/* prototipusok */
void initHW(void);
void buttonIRQHandler(void *CallBackRef);
void timerIRQHandler(void *CallBackRef, uint8_t TmrCtrNumber);
void readBMP(FIL* fp, uint16_t image[32][32]);
void drawImage(uint16_t image[32][32]);
void clearDisplay(void);
int main(void);


/* inicializalja a periferiakat */
void initHW(void){
	static XTmrCtr timer;
	static XScuGic intc;
	XScuGic_Config *cfg;
	/* GPIO */
	XGpio_Initialize(&gpioLED,XPAR_AXI_GPIO_LED_DEVICE_ID);
	XGpio_SetDataDirection(&gpioLED,1,0x00);
	XGpio_DiscreteWrite(&gpioLED,1,0x00);
	XGpio_Initialize(&gpioSW,XPAR_AXI_GPIO_SW_DEVICE_ID);
	XGpio_SetDataDirection(&gpioSW,1,0xFF);
	XGpio_Initialize(&gpioBTN,XPAR_AXI_GPIO_BTN_DEVICE_ID);
	XGpio_SetDataDirection(&gpioBTN,1,0xFF);
	/* AXI Timer/Counter */
	XTmrCtr_Initialize(&timer,XPAR_AXI_TIMER_0_DEVICE_ID);
	XTmrCtr_SetHandler(&timer,timerIRQHandler,&timer);
	XTmrCtr_SetOptions(&timer,0,XTC_INT_MODE_OPTION|XTC_AUTO_RELOAD_OPTION);
	XTmrCtr_SetResetValue(&timer,0,0xFFFFFFFF-500000000);
	XTmrCtr_Start(&timer,0);
	/* megszakitasok */
	cfg=XScuGic_LookupConfig(XPAR_PS7_SCUGIC_0_DEVICE_ID);
	XScuGic_CfgInitialize(&intc,cfg,cfg->CpuBaseAddress);
	XScuGic_Connect(&intc,XPAR_FABRIC_AXI_GPIO_BTN_IP2INTC_IRPT_INTR,(Xil_ExceptionHandler)(buttonIRQHandler),&gpioBTN);
	XScuGic_Connect(&intc,XPAR_FABRIC_AXI_TIMER_0_INTERRUPT_INTR,(Xil_ExceptionHandler)(timerIRQHandler),&timer);
	XScuGic_Enable(&intc,XPAR_FABRIC_AXI_GPIO_BTN_IP2INTC_IRPT_INTR);
	XScuGic_Enable(&intc,XPAR_FABRIC_AXI_TIMER_0_INTERRUPT_INTR);
	XGpio_InterruptEnable(&gpioBTN,XGPIO_IR_CH1_MASK);
	XGpio_InterruptGlobalEnable(&gpioBTN);
	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,(Xil_ExceptionHandler)XScuGic_InterruptHandler,&intc);
	Xil_ExceptionEnable();
}

/* nyomogomb megszakitaskezelo */
void buttonIRQHandler(void *CallBackRef){
	if((XGpio_InterruptGetStatus(CallBackRef)&XGPIO_IR_CH1_MASK)!=XGPIO_IR_CH1_MASK) return;
	XGpio_InterruptDisable(CallBackRef,XGPIO_IR_CH1_MASK);
	if(XGpio_DiscreteRead(CallBackRef,1)==0x02){
		clearDisplay();
		displayEnabled=0;
		XGpio_DiscreteWrite(&gpioLED,1,0x00);
	}
	else if((displayEnabled==0)&&(XGpio_DiscreteRead(CallBackRef,1)==0x10)){
		displayEnabled=1;
		drawNext=1;
	}
	XGpio_InterruptClear(CallBackRef,XGPIO_IR_CH1_MASK);
	XGpio_InterruptEnable(CallBackRef,XGPIO_IR_CH1_MASK);
}

/* AXI Timer/Counter megszakitaskezelo */
void timerIRQHandler(void *CallBackRef, uint8_t TmrCtrNumber){
	XTmrCtr_Stop(CallBackRef,0);
	drawNext=1;
	XTmrCtr_Reset(CallBackRef,0);
	XTmrCtr_Start(CallBackRef,0);
}

/* az atadott tombot feltolti a kepfajlbol kiolvasott tartalommal (csak 32x32 pixel, 24 bpp) */
void readBMP(FIL* fp, uint16_t image[32][32]){
	UINT bytesRead;
	uint32_t size, offset, row, col;
	uint8_t* fileBuffer;
	size=file_size(fp);
	fileBuffer=malloc(size);
	f_read(fp,fileBuffer,size,&bytesRead);
	if(bytesRead!=size){
		free(fileBuffer);
		f_close(fp);
		return;
	}
	offset=((fileBuffer[13]<<24)|(fileBuffer[12]<<16)|(fileBuffer[11]<<8)|fileBuffer[10])+93;
	for(row=0;row<32;row++){
		for(col=0;col<32;col++){
			uint8_t r=fileBuffer[offset+2]>>4;
			uint8_t g=fileBuffer[offset+1]>>4;
			uint8_t b=fileBuffer[offset+0]>>4;
			image[row][col]=(b<<8)|(g<<4)|r; //0000_bbbb_gggg_rrrr
			offset-=3;
		}
		offset+=192;
	}
	free(fileBuffer);
	f_close(fp);
}

/* az atadott kepet AXI buszon kiirja a frame buffer BRAM-ba, es megjelenik a kijelzon */
void drawImage(uint16_t image[32][32]){
	uint8_t row1, row2, col;
	uint16_t i, color1, color2;
	for(i=0;i<512;i++){
		row1=(i%64<32)?(i/64):(i/64+16);
		row2=row1+8;
		col=i%32;
		color1=image[row1][col];
		color2=image[row2][col];
		Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR+(i<<2),(color2<<12)|color1);
	}
}

/* elsotetiti a kijelzot */
void clearDisplay(void){
	uint16_t i;
	for(i=0;i<512;i++) Xil_Out32(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR+(i<<2),0);
}

/* foprogram, ciklikusan olvassa be es rajzolja ki a kepeket */
int main(void){
	FATFS fs;
	FIL file;
	uint16_t fileCntr=1;
	char fileName[16];
	uint16_t image[32][32] __attribute__((aligned(32)));
	initHW();
	if(f_mount(&fs,"0:/",1)!=FR_OK) while(1) ;
	while(1){
		if(displayEnabled && drawNext){
			drawNext=0;
			sprintf(fileName,"img%d.bmp",fileCntr);
			if(f_open(&file,fileName,FA_READ)!=FR_OK){
				fileCntr=1;
				if(f_open(&file,"img1.bmp",FA_READ)!=FR_OK) while(1) ;
			}
			readBMP(&file,image);
			drawImage(image);
			XGpio_DiscreteWrite(&gpioLED,1,fileCntr);
			fileCntr++;
		}
	}
	return 0;
}
