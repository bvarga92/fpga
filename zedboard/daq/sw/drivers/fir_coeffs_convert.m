clear all;
clc;

fs=96;
h128=load('fir_coeffs_128.fcf');
h256=load('fir_coeffs_256.fcf');
h512=load('fir_coeffs_512.fcf');

[H128,W128]=freqz(h128,1,5000);
[H256,W256]=freqz(h256,1,5000);
[H512,W512]=freqz(h512,1,5000);
plot(W128/pi*fs/2,20*log10(abs(H128)),'b');
hold on;
plot(W256/pi*fs/2,20*log10(abs(H256)),'r');
plot(W512/pi*fs/2,20*log10(abs(H512)),'g');
hold off;
grid on;
xlim([0 fs/2]);
xlabel('f [kHz]');
ylabel('|H| [dB]');
legend('1x (128)','2x (256)','4x (512)');

f=fopen('fir_coeffs.h','w');
fprintf(f,'#ifndef _FIR_COEFFS_H_\n\r');
fprintf(f,'#define _FIR_COEFFS_H_\n\r\n\r');
fprintf(f,'#include "xil_types.h"\n\r\n\r');
fprintf(f,'const int32_t coeffs128[128]={\n\r');
fprintf(f,'%d,\n\r',int32(h128*(2^31-1)));
fprintf(f,'};\n\r\n\r');
fprintf(f,'const int32_t coeffs256[256]={\n\r');
fprintf(f,'%d,\n\r',int32(h256*(2^31-1)));
fprintf(f,'};\n\r\n\r');
fprintf(f,'const int32_t coeffs512[512]={\n\r');
fprintf(f,'%d,\n\r',int32(h512*(2^31-1)));
fprintf(f,'};\n\r\n\r');
fprintf(f,'#endif\n\r');
fclose(f);
