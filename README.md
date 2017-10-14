# FPGA projektek és vegyes HDL modulok

Az egyes projektekben található .ucf fájlok a [Digilent Nexys 3](https://www.xilinx.com/products/boards-and-kits/1-27b7nm.html) fejlesztõkártyához érvényesek.

- **pmodAD1_audio_fft**: 64 pontos audio spektrumanalizátor RGB LED mátrix kijelzéssel, PmodAD1 ADC modullal ([videó](https://www.youtube.com/watch?v=fEciQDGBcTs&list=PL9_VlVdB8s882QMHiqJlDpJeKWxwP5CIG))
- **pmodALS_test**: mintaprojekt a Digilent PmodALS megvilágításmérõ modulhoz
- **pmodDA4_dds**: kétcsatornás DDS jelgenerátor PmodDA4 DAC modullal ([videó](https://www.youtube.com/watch?v=8Ri7BkQX_lQ&list=PL9_VlVdB8s882QMHiqJlDpJeKWxwP5CIG))
- **pmodMIC3_pmodI2S**: a PmodMIC3 mikrofon modul jelének átjátszása a PmodI2S audio kimenetre
- **pmodPS2_vga_calc**: MicroBlaze alapú számológép PS/2 billentyûzet bemenettel, VGA kimenettel ([videó](https://www.youtube.com/watch?v=zgfqkkt5U_M&list=PL9_VlVdB8s882QMHiqJlDpJeKWxwP5CIG))
- **zedboard**: a [ZedBoard](http://zedboard.org/product/zedboard) Zynq SoPC fejleszõkártyára készült projektek
- **cntr_sec.v** és **cntr_sec.vhd**: másodpercszámláló Verilog és VHDL nyelven
- **knightrider.v** és **knightrider.vhd**: futófény Verilog és VHDL nyelven
- **rotary_encoder.v**: inkrementális szögadó kezelése
- **uart.v**: UART adó (115200 bps, 8 adatbit, páratlan paritás, 1 stopbit)
- **verilog_beautifier.php**: syntax highlighter a Verilog nyelvhez ([próba](https://home.sch.bme.hu/~bvarga92/upload/_labor/verilog_beautifier.php))
- **verilog_feladatok.pdf**: egyszerû FPGA-s gyakorlófeladatok megoldásokkal
