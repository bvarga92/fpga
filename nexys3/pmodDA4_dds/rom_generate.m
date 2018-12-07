clear all;
clc;

file='rom.txt'; %fajlnev
N=1024; %mintaszam
B=12; %bitszam
x=sin(2*pi/N*(0:N-1))+5; %a jel egy periodusa

x=x-min(x);
x=round(x/max(x)*(2^B-1));
plot(0:N-1,x);
grid on;
axis([0 N 0 2^B-1]);
f=fopen(file,'w');
fprintf(f,'%03X\r\n',x);
fclose(f);
