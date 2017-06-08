clear all;
clc;

fs=96000;
N=401;
f=[0  4000  5000  10000  11000  fs/2];
a=[1    1     0     0      1      1 ];

h=firpm(N-1,f/(fs/2),a);
[H,w]=freqz(h,1,8192);
plot(w/pi*fs/2000,20*log10(abs(H)));
xlim([0 fs/2000]);
xlabel('f [kHz]');
ylabel('|H| [dB]');
f=fopen('coeffs.dat','w');
fprintf(f,'%d,\n',int32(h*(2^31-1)));
fclose(f);
