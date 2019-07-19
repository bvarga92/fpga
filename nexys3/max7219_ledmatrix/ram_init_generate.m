clear all;
clc;

imfiles=dir('ram_init*.bmp'); % 32x32 meretu, 1 bpp szinmelysegu kepek

fp=fopen('ram_init.txt','w');
for ii=1:length(imfiles)
    [I,ff]=imread(imfiles(ii).name);
    fprintf(fp,'0B070B070B070B070B070B070B070B070B070B070B070B070B070B070B070B07\n');
    fprintf(fp,'0900090009000900090009000900090009000900090009000900090009000900\n');
    fprintf(fp,'0F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F00\n');
    fprintf(fp,'0A000A000A000A000A000A000A000A000A000A000A000A000A000A000A000A00\n');
    fprintf(fp,'0C010C010C010C010C010C010C010C010C010C010C010C010C010C010C010C01\n');
    for reg=1:8
        for row=4:-1:1
            for col=1:4
                byte=~I(row*8-reg+1,col*8:-1:col*8-7);
                fprintf(fp,'%04X',reg*256+sum(byte(1:4).*(2.^(3:-1:0)),2)*16+sum(byte(5:8).*(2.^(3:-1:0)),2));
            end
        end
        fprintf(fp,'\n');
    end
    figure(ii);
    imagesc(I);
    axis square;
    colormap gray;
end
fclose(fp);
