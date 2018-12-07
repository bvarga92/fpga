% Lookup table a komplex egyutthatokhoz.

clear all;
clc;
N=128; %hany pontos FFT (kettohatvany!)

w_re=real(exp(-j*2*pi/N*(0:N/2-1)));
w_im=imag(exp(-j*2*pi/N*(0:N/2-1)));
for ii=1:length(w_re)
    if w_re(ii)>=0
        w_re(ii)=floor(w_re(ii)*4095);
    else
        w_re(ii)=w_re(ii)+1;
        w_re(ii)=4096+floor(w_re(ii)*4095);
    end
    if w_im(ii)>=0
        w_im(ii)=floor(w_im(ii)*4095);
    else
        w_im(ii)=w_im(ii)+1;
        w_im(ii)=4096+floor(w_im(ii)*4095);
    end
end
w_re=dec2bin(w_re,13);
w_im=dec2bin(w_im,13);
f=fopen('twiddle.v','w');
fprintf(f,'`timescale 1ns / 1ps\r\n');
fprintf(f,'module twiddle(input[%d:0] addr, output reg signed [12:0] w_re,w_im);\r\n\r\n',log2(N/2)-1);
fprintf(f,'  always@(*)\r\n');
fprintf(f,'    case(addr)\r\n');
for ii=0:N/2-1
    fprintf(f,'      %d\''d%d: \r\n',log2(N/2),ii);
    fprintf(f,'        begin\r\n');
    fprintf(f,'          w_re<=13''b%s;\r\n',w_re(ii+1,:));
    fprintf(f,'          w_im<=13''b%s;\r\n',w_im(ii+1,:));
    fprintf(f,'        end\r\n');
end
fprintf(f,'    endcase\r\n\r\n');
fprintf(f,'endmodule\r\n');
fclose(f);
