# MicroBlaze alapú számológép

A **hw** mappa tartalmazza a rendszer elemeit leíró **MHS** fájlt, a lábkiosztást tartalmazó **UCF** fájlt, valamint a **pcores** almappában a megvalósított perifériák hardverleíró kódjait (VGA, billentyűzet, LED-ek és kapcsolók). Az **sw** mappában a MicroBlaze CPU által futtatott kód található. A **BIT** fájl tartalmazza a teljes projektet, a programmemóriához tartozó blokk RAM-okat az elkészült szoftver kódjával inicializálja.


![A rendszer blokkvázlata](https://raw.githubusercontent.com/bvarga92/fpga/main/nexys3/pmodPS2_vga_calc/blokkvazlat.png)
