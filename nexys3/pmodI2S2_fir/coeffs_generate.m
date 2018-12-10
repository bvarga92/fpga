clear all;
clc;

fs=48e3;

% h=fir1(255,5000/fs*2);
h=firpm(255,[0 5000 5500 24000]/fs*2,[1 1 0 0]);

[H,w]=freqz(h,1,8192);
figure(1);
plot(w/pi*fs/2,20*log10(abs(H)));
xlim([0 fs/2]);
xlabel('f [Hz]');
ylabel('|H(f)| [dB]');

fp=fopen('coeffs.txt','w');
for ii=1:length(h)
    hi=sprintf('%016X',typecast(int64(h(ii)*(2^31-1)),'uint64'));
    fprintf(fp,'%s\r\n',hi(8:end));
end
fclose(fp);
