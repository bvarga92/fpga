/*****************************************************************************/
/*                                                                           */
/* RGB LED matrix vezerlo.                                                   */
/*                                                                           */
/*   - 16x64-es kijelzo                                                      */
/*   - 12 bites szinmelyseg                                                  */
/*                                                                           */
/*****************************************************************************/

`timescale 1ns / 1ps

module ledmtx(
	input rst,               //reset
	input clk,               //rendszerorajel
	input enn,               //kijelzo ki- es bekapcsolasa
	output reg[2:0] rowaddr, //sorkivalaszto jel
	output reg sclk,         //orajel
	output oe,               //output enable
	output lat,              //latch
	output r1,               //also sor piros
	output g1,               //also sor zold
	output b1,               //also sor kek
	output r2,               //felso sor piros
	output g2,               //felso sor zold
	output b2,               //felso sor kek
	output[8:0] ram_addr,    //frame buffer cim
	input[23:0] ram_data,    //frame buffer adat
	output done              //1, ha kesz a frame buffer kirajzolasa
);

	/* sorvaltas jelzo */
	reg newline;

	/* utemezo szamlalo */
	reg[14:0] cntr;
	always@(posedge clk)
		if(rst)
			cntr<=0;
		else if((cntr>=819)&(~newline))
			cntr<=0;
		else
			cntr<=cntr+1'b1;

	/* engedelyezojel (sclk frekvenicajanak duplaja) */
	reg[2:0] encntr;
	reg en;
	always@(posedge clk)
		encntr<=(rst|en|(cntr==819))?(3'd0):(encntr+1'b1);
	always@(posedge clk)
		en<=(encntr==4); //16.7 MHz en, 8.3 MHz sclk (a jelenlegi kabellel ez mar hatareset)

	/* orajel */
	always@(posedge clk)
		if(rst)
			sclk<=1'b1;
		else if(en&(cntr<773))
			sclk<=~sclk;

	/* PWM keret szamlalo */
	reg[3:0] frame;
	always@(posedge clk)
		if(rst)
		begin
			newline<=0;
			frame<=4'd1;
		end
		else if(cntr==810)
		begin
			if(frame==15)
			begin
				newline<=1'b1;
				frame<=4'd1;
			end
			else
				frame<=frame+1'b1;
		end
		else if(cntr==30800) //sorvaltaskor varunk egy kicsit (kulonben ghosting!)
			newline<=0;

	/* sorszamlalo */
	always@(posedge clk)
		if(rst)
			rowaddr<=0;
		else if(cntr==3000)
			rowaddr<=rowaddr+1'b1;
			
	/* oszlopszamlalo */
	reg[5:0] col;
	always@(posedge clk)
		if(rst)
			col<=6'd63;
		else if(en&sclk&(cntr<762))
			col<=col+1'b1;

	/* memoriacim={sor,oszlop} */
	assign ram_addr={rowaddr,col};

	/* adat olvasasa a memoriabol */
	assign r1=(ram_data[3:0]<frame)?(1'b0):(1'b1);
	assign g1=(ram_data[7:4]<frame)?(1'b0):(1'b1);
	assign b1=(ram_data[11:8]<frame)?(1'b0):(1'b1);
	assign r2=(ram_data[15:12]<frame)?(1'b0):(1'b1);
	assign g2=(ram_data[19:16]<frame)?(1'b0):(1'b1);
	assign b2=(ram_data[23:20]<frame)?(1'b0):(1'b1);

	/* latch jel, ha kesz a shifteles */
	assign lat=(cntr>=780)&(cntr<=804);

	/* latcheleskor es sorvaltaskor kikapcsoljuk a kijelzot */
	assign oe=enn | ((cntr>=768)&(cntr<=819)) | ((frame==1)&((cntr>=1588)|(cntr<=819)));
	
	/* jelezzuk, ha kiirtuk a frame buffert */
	assign done=(rowaddr==0)&(cntr>3000);

endmodule
