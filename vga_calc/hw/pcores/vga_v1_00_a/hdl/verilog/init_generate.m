clear all;
clc;
mem=zeros(128*128,1);
for col=0:99
	for row=0:74
        if (row<3)||(row>71)
            r=7*(mod(row,3)==0);
            g=7*(mod(row,3)==1);
            b=3*(mod(row,3)==2);
        else
            r=7*(mod(col,3)==0);
            g=7*(mod(col,3)==1);
            b=3*(mod(col,3)==2);
        end
		mem(1+row*128+col)=r*32+g*4+b;
	end
end
f=fopen('init.txt','w');
for ii=1:128*128
	fprintf(f,'%02X\r\n',uint8(mem(ii)));
end
fclose(f);
