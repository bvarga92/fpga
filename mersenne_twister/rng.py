def rng(seed):
    w=32
    n=624
    m=397
    r=31
    a=0x9908B0DF
    u=11
    d=0xFFFFFFFF
    s=7
    b=0x9D2C5680
    t=15
    c=0xEFC60000
    l=18
    f=1812433253
    lower_mask=(1<<r)-1
    upper_mask=(~lower_mask)&((1<<w)-1)
    idx=n
    MT=[]
    MT.append(seed)
    for i in range(1,n):
        MT.append(((MT[i-1]^(MT[i-1]>>(w-2)))*f+i)&((1<<w)-1))
    while True:
        if idx>=n:
            for i in range(n):
                x=(MT[i]&upper_mask)|(MT[(i+1)%n]&lower_mask)
                MT[i]=MT[(i+m)%n]^(x>>1)
                if x&1: MT[i]^=a
            idx=0
        x=MT[idx]
        x^=(x>>u)&d
        x^=(x<<s)&b
        x^=(x<<t)&c
        x^=(x>>l)
        idx+=1
        yield x

myRNG=rng(5489)
for i in range(20):
    print("%10u"%next(myRNG))