clear all;
clc;

%% parameterek (MT19937)
w=32;
n=624;
m=397;
r=31;
a=hex2dec('9908B0DF');
u=11;
d=hex2dec('FFFFFFFF');
s=7;
b=hex2dec('9D2C5680');
t=15;
c=hex2dec('EFC60000');
l=18;
f=1812433253;
seed=5489;

%% inicializalas
lower_mask=bitshift(1,r)-1;
upper_mask=bitand(bitcmp(lower_mask),bitshift(1,w)-1);
idx=n+1;
MT=zeros(1,n,'uint32');
MT(1)=seed;
for ii=2:n
    MT(ii)=bitand(uint64(bitxor(MT(ii-1),bitshift(MT(ii-1),2-w,'uint32'),'uint32'))*f+ii-1,bitshift(1,w)-1);
end

%% generalas
samplesToGenerate=10000;
rnd=zeros(1,samplesToGenerate,'uint32');
for jj=1:samplesToGenerate
    if idx>n
        for ii=1:n
            x=bitand(MT(ii),upper_mask,'uint32')+bitand(MT(mod(ii,n)+1),lower_mask,'uint32');
            if mod(x,2)~=0
                x=bitxor(bitshift(x,-1),a,'uint32');
            else
                x=bitshift(x,-1);
            end
            MT(ii)=bitxor(MT(mod(ii+m-1,n)+1),x,'uint32');
        end
        idx=1;
    end
    x=MT(idx);
    x=bitxor(x,bitand(bitshift(x,-u,'uint32'),d,'uint32'),'uint32');
    x=bitxor(x,bitand(bitshift(x,s,'uint32'),b,'uint32'),'uint32');
    x=bitxor(x,bitand(bitshift(x,t,'uint32'),c,'uint32'),'uint32');
    x=bitxor(x,bitshift(x,-l,'uint32'),'uint32');
    x=bitand(x,bitshift(1,w)-1);
    idx=idx+1;
    rnd(jj)=x;
end

%% abrazolas
figure(1);
subplot(121);
plot(rnd);
xlim([1 samplesToGenerate]);
subplot(122);
hist(double(rnd),100);