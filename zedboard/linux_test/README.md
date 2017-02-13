A hardverdizájn a *first* projektben találhatóhoz teljesen hasonló, az egyetlen különbség, hogy két további AXI GPIO periféria található benne a gomboknak és a kapcsolóknak. Szintézis és implementáció után SDK-ban egy FSBL alkalmazást (First Stage BootLoader) kell generálni és fordítani.

A PetaLinux fordítása nagyrészt az alapértelmezett beállításokkal történhet, csak a dropbear és dropbear-openssh-sftp-server komponenseket kell még bekapcsolni. Az elkészült *image.ub* fájlt fel kell másolni az SD kártyára, ez tartalmazza a Linux kernelt és a root fájlrendszert.

A fordítás végeztével az SDK-ban boot image-et kell generálni az FSBL alkalmazás ELF fájljából, a hardver BIT fájlból, és az u-boot.elf-ből. Az így kapott *BOOT.bin* fájlt szintén fel kell másolni az SD kártyára.

A *drv/gpio* a LED-ek, kapcsolók és nyomógombok programból történő kezelésére mutat példát. A *drv/gpio_kernel* egy betölthető kernel modult tartalmaz, amely a LED-eken számolja a másodperceket.
