clear all;
clc;

fs=48e3; % mintaveteli frekvencia [Hz]
tempo=4; % egy egeszhang ideje [s]
% zongorabillentyuk sorrendje es az egyes hangok idotartama
music_n=[40  44  40  44  47  47  40  44  40  44  47  47  52  51  49  47  45  49  47  45  44  42  40  40];
music_t=[1/8 1/8 1/8 1/8 1/4 1/4 1/8 1/8 1/8 1/8 1/4 1/4 1/8 1/8 1/8 1/8 1/4 1/4 1/8 1/8 1/8 1/8 1/4 1/4];

f=440*2.^(((1:88)-49)/12);
L=round(fs./f-1/2);
rng(132);
init=rand(1,max(L))*2-1;
out=[];
for ii=1:length(music_n)
    note=zeros(1,music_t(ii)*tempo*fs);
    buf=init;
    idx=1;
    dl=0;
    for jj=1:length(note)
        note(jj)=0.5*(buf(idx)+dl);
        dl=buf(idx);
        buf(idx)=note(jj);
        idx=mod(idx,L(music_n(ii)))+1;
    end
    out=[out note];
end

plot((0:length(out)-1)/fs,out);
sound(out,fs);

fp=fopen('init.txt','w');
for ii=1:length(init)
    hi=sprintf('%08X',typecast(int32(init(ii)*(2^23-1)),'uint32'));
    fprintf(fp,'%s\r\n',hi(3:end));
end
fclose(fp);