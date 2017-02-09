#include "led_sw.h"
#include "vga.h"
#include "ps2_keyboard.h"

#define OPDIGITS 4           //operandusok maximalis hossza
#define BGCOLOR  COLOR_WHITE //hatterszin
#define CHCOLOR  COLOR_LBLUE //betuszin
#define ERCOLOR  COLOR_RED   //hibauzenet szine
#define OPS_X    70          //operandusok X (jobb szel)
#define OP1_Y    18          //elso operandus Y
#define OP2_Y    28          //masodik operandus Y
#define SIGN_X   15          //muveleti jel X
#define LINE_Y   38          //vonal Y
#define RES_Y    42          //eredmeny Y

void initScreen(){
	vgaClearScreen(BGCOLOR);
	vgaPutChar('0',OPS_X,OP1_Y,CHCOLOR,BGCOLOR);
	vgaPutChar('0',OPS_X,OP2_Y,CHCOLOR,BGCOLOR);
	vgaPutChar('?',SIGN_X,OP2_Y,CHCOLOR,BGCOLOR);
	vgaDrawLine(SIGN_X,LINE_Y,OPS_X+8,LINE_Y,CHCOLOR);
	vgaPutChar('?',OPS_X,RES_Y,CHCOLOR,BGCOLOR);
}

int main(void){
	ubyte state, operation, neg, null;
	int16_t c;
	int32_t op_a, op_b;
	initScreen();
	while(!kbIsEmpty()) kbGetChar();
	state=neg=null=0;
	op_a=op_b=0;
	while(1){
		/* billentyure varunk */
		setLED(state);
		do{c=kbGetChar();} while(c==-1);
		/* elso operandus gepelese zajlik */
		if(((state==0)&&(c=='-')&&(!null))||((state<OPDIGITS)&&(c>=0x30)&&(c<=0x39))){
			if(op_a==0){
				initScreen();
				if(c=='0'){
					null=1;
					continue;
				}
				if(c=='-'){
					neg=1;
					vgaPutChar('-',OPS_X-8,OP1_Y,CHCOLOR,BGCOLOR);
					continue;
				}
			}
			op_a=neg?(op_a*10-(c-0x30)):(op_a*10+(c-0x30));
			vgaPrintInt(op_a,OPS_X-8*(state+neg),OP1_Y,CHCOLOR,BGCOLOR);
			state++;
			continue;
		}
		/* megjott a muveleti jel */
		else if((null||(state<=OPDIGITS))&&((c=='+')||(c=='-')||(c=='*')||(c=='/'))){
			neg=0;
			null=0;
			vgaPutChar(c,SIGN_X,OP2_Y,CHCOLOR,BGCOLOR);
			state=OPDIGITS+1;
			operation=c;
		}
		/* masodik operandus gepelese zajlik */
		else if(((state==OPDIGITS+1)&&(c=='-'))||((state>=OPDIGITS+1)&&(state<2*OPDIGITS+1)&&(c>=0x30)&&(c<=0x39))){
			if(op_b==0){
				if(c=='0'){
					null=1;
					continue;
				}
				if(c=='-'){
					neg=1;
					vgaPutChar('-',OPS_X-8,OP2_Y,CHCOLOR,BGCOLOR);
					continue;
				}
			}
			op_b=neg?(op_b*10-(c-0x30)):(op_b*10+(c-0x30));
			vgaPrintInt(op_b,OPS_X-8*(state-OPDIGITS-1+neg),OP2_Y,CHCOLOR,BGCOLOR);
			state++;
			continue;
		}
		/* leutottek az entert */
		else if((state>=OPDIGITS+1)&&(c==0x0D)){
			if((operation=='/')&&(op_b==0)){
				vgaPrint("ERROR",OPS_X-32,RES_Y,ERCOLOR,BGCOLOR);
			}
			else{
				ubyte digits=1;
				int32_t result, n;
				switch(operation){
					case '*': result=op_a*op_b; break;
					case '+': result=op_a+op_b; break;
					case '-': result=op_a-op_b; break;
					case '/': result=op_a/op_b;
				}
				n=result;
				if(n<0){digits++; n=-n;}
				while(n>9){digits++; n/=10;}
				vgaPrintInt(result,OPS_X+8-digits*8,RES_Y,CHCOLOR,BGCOLOR);
			}
			state=neg=null=0;
			op_a=op_b=0;
		}
   }
   return 0;
}
