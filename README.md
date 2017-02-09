# FPGA projektek és vegyes HDL modulok

Az egyes projektekben található .ucf fájlok a [Digilent Nexys 3](https://www.xilinx.com/products/boards-and-kits/1-27b7nm.html) fejlesztõkártyához érvényesek.

- **audio_fft**: 64 pontos audio spektrumanalizátor RGB LED mátrix kijelzéssel ([videó](https://www.youtube.com/watch?v=fEciQDGBcTs&list=PL9_VlVdB8s882QMHiqJlDpJeKWxwP5CIG))
- **pmod_als**: mintaprojekt a Digilent PmodALS megvilágításmérõ modulhoz
- **pmod_da4_dds**: kétcsatornás DDS jelgenerátor a PmodALS modullal ([videó](https://www.youtube.com/watch?v=8Ri7BkQX_lQ&list=PL9_VlVdB8s882QMHiqJlDpJeKWxwP5CIG))
- **vga_calc**: MicroBlaze softcore CPU-n alapuló számológép PS/2 billentyûzet bemenettel, VGA kimenettel ([videó](https://www.youtube.com/watch?v=zgfqkkt5U_M&list=PL9_VlVdB8s882QMHiqJlDpJeKWxwP5CIG))
- **cntr_sec.v** és **cntr_sec.vhd**: másodpercszámláló Verilog és VHDL nyelven
- **knightrider.v** és **knightrider.vhd**: futófény Verilog és VHDL nyelven
- **rotary_encoder.v**: inkrementális szögadó kezelése
- **uart.v**: UART adó (115200 bps, 8 adatbit, páratlan paritás, 1 stopbit)
