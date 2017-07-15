clear all;
clc;
mem=zeros(640*480,1);
img=zeros(480,640,3);
for col=0:639
    for row=0:479
        [r g b]=hsv2rgb([col/640 1 0.8]);
        r=round(15*r);
        g=round(15*g);
        b=round(15*b);
        img(row+1,col+1,1)=round(r)/15;
        img(row+1,col+1,2)=round(g)/15;
        img(row+1,col+1,3)=round(b)/15;
        mem(1+640*row+col)=r*256+g*16+b;
    end
end
f=fopen('fb_init.coe','w');
fprintf(f,'memory_initialization_radix=16;\n');
fprintf(f,'memory_initialization_vector=\n');
for ii=1:640*480-1
    fprintf(f,'%04X,\n',uint16(mem(ii)));
end
fprintf(f,'%04X;',uint16(mem(end)));
fclose(f);
imshow(img);
