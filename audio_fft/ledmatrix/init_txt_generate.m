clear all;
clc;
scale=0.5; %globalis fenyero skalazas (0...1) 

x=imread('init.bmp');
if size(x)==[16 64 3]
    disp('Kepmeret OK!');
end
r=uint8(double(x(:,:,1))*15/255*scale);
g=uint8(double(x(:,:,2))*15/255*scale);
b=uint8(double(x(:,:,3))*15/255*scale);
f=fopen('init.txt','w');
for ii=16:-1:9
    for jj=64:-1:1
        fprintf(f,'%X%X%X',b(ii-8,jj),g(ii-8,jj),r(ii-8,jj));
        fprintf(f,'%X%X%X\r\n',b(ii,jj),g(ii,jj),r(ii,jj));
    end
end
fclose(f);
