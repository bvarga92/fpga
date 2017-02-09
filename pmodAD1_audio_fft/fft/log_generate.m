% Lookup table a logaritmushoz.

clear all;
clc;
N=7; % bitszam

x=0:2^N-1;
x_bin=dec2bin(x,N);
x_log=[0 log(x(2:end))];
x_log=floor(x_log/max(x_log)*(2^N-1));
x_log_bin=dec2bin(x_log,N);
plot(x,x,x,x_log);
f=fopen('log.v','w');
fprintf(f,'`timescale 1ns / 1ps\r\n');
fprintf(f,'module log(input[%d:0] n, output reg[%d:0] nlog);\r\n\r\n',N-1,N-1);
fprintf(f,'  always@(*)\r\n');
fprintf(f,'    case(n)\r\n');
for ii=1:2^N
    fprintf(f,'      %d\''b%s: ',N,x_bin(ii,:));    
    fprintf(f,'nlog<=%d''b%s;\r\n',N,x_log_bin(ii,:));
end
fprintf(f,'    endcase\r\n\r\n');
fprintf(f,'endmodule\r\n');
fclose(f);
