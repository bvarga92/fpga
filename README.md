# FPGA projektek �s vegyes HDL modulok

Az egyes projektekben tal�lhat� .ucf f�jlok a [Digilent Nexys 3](https://www.xilinx.com/products/boards-and-kits/1-27b7nm.html) fejleszt�k�rty�hoz �rv�nyesek.

- **pmodAD1_audio_fft**: 64 pontos audio spektrumanaliz�tor RGB LED m�trix kijelz�ssel, PmodAD1 ADC modullal ([vide�](https://www.youtube.com/watch?v=fEciQDGBcTs&list=PL9_VlVdB8s882QMHiqJlDpJeKWxwP5CIG))
- **pmodALS_test**: mintaprojekt a Digilent PmodALS megvil�g�t�sm�r� modulhoz
- **pmodDA4_dds**: k�tcsatorn�s DDS jelgener�tor PmodDA4 DAC modullal ([vide�](https://www.youtube.com/watch?v=8Ri7BkQX_lQ&list=PL9_VlVdB8s882QMHiqJlDpJeKWxwP5CIG))
- **pmodMIC3_pmodI2S**: a PmodMIC3 mikrofon modul jel�nek �tj�tsz�sa a PmodI2S audio kimenetre
- **pmodPS2_vga_calc**: MicroBlaze alap� sz�mol�g�p PS/2 billenty�zet bemenettel, VGA kimenettel ([vide�](https://www.youtube.com/watch?v=zgfqkkt5U_M&list=PL9_VlVdB8s882QMHiqJlDpJeKWxwP5CIG))
- **zedboard**: a [ZedBoard](http://zedboard.org/product/zedboard) Zynq SoPC fejlesz�k�rty�ra k�sz�lt projektek
- **cntr_sec.v** �s **cntr_sec.vhd**: m�sodpercsz�ml�l� Verilog �s VHDL nyelven
- **knightrider.v** �s **knightrider.vhd**: fut�f�ny Verilog �s VHDL nyelven
- **rotary_encoder.v**: inkrement�lis sz�gad� kezel�se
- **uart.v**: UART ad� (115200 bps, 8 adatbit, p�ratlan parit�s, 1 stopbit)
- **verilog_beautifier.php**: syntax highlighter a Verilog nyelvhez ([pr�ba](https://home.sch.bme.hu/~bvarga92/upload/_labor/verilog_beautifier.php))
- **verilog_feladatok.pdf**: egyszer� FPGA-s gyakorl�feladatok megold�sokkal
