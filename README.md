# FPGA projektek �s vegyes HDL modulok

Az egyes projektekben tal�lhat� .ucf f�jlok a [Digilent Nexys 3](https://www.xilinx.com/products/boards-and-kits/1-27b7nm.html) fejleszt�k�rty�hoz �rv�nyesek.

- **pmodAD1_audio_fft**: 64 pontos audio spektrumanaliz�tor RGB LED m�trix kijelz�ssel, PmodAD1 ADC modullal ([vide�](https://www.youtube.com/watch?v=fEciQDGBcTs&list=PL9_VlVdB8s882QMHiqJlDpJeKWxwP5CIG))
- **pmodALS**: mintaprojekt a Digilent PmodALS megvil�g�t�sm�r� modulhoz
- **pmodDA4_dds**: k�tcsatorn�s DDS jelgener�tor PmodDA4 DAC modullal ([vide�](https://www.youtube.com/watch?v=8Ri7BkQX_lQ&list=PL9_VlVdB8s882QMHiqJlDpJeKWxwP5CIG))
- **pmodPS2_vga_calc**: MicroBlaze alap� sz�mol�g�p PS/2 billenty�zet bemenettel, VGA kimenettel ([vide�](https://www.youtube.com/watch?v=zgfqkkt5U_M&list=PL9_VlVdB8s882QMHiqJlDpJeKWxwP5CIG))
- **cntr_sec.v** �s **cntr_sec.vhd**: m�sodpercsz�ml�l� Verilog �s VHDL nyelven
- **knightrider.v** �s **knightrider.vhd**: fut�f�ny Verilog �s VHDL nyelven
- **rotary_encoder.v**: inkrement�lis sz�gad� kezel�se
- **uart.v**: UART ad� (115200 bps, 8 adatbit, p�ratlan parit�s, 1 stopbit)
