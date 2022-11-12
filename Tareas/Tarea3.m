clc
close all 
clear all

filename = 'OSR_us_000_0016_8k.wav';
[y,Fs] = audioread(filename);
ts=1/Fs;

 y = y(:,1);
    t = 0:ts:(length(y)*ts)-ts;

    %figure(1)
    %plot(t,y); 
    %xlabel('Segundos'); 
    %ylabel('Amplitud');

    S = bandpower(y);
    %IDS=max(y)+abs(min(y));
    IDS= 2*max(y);
    p=1:16;

   
    IDQ=2.^p;
    q=IDS./IDQ;

    Q=1/12 * q.^2;



SQR=10*log10(S./Q);




[p' SQR' q']

%-----------------------------
clear  p Q SQR

p=1:6;
q=0.0023*ones(1,6);

IDQ=2.^p;

for k=1:6
    Q(k)=1/12 * q(k)^2;
    SQR(k)=10*log10(S./Q(k));
end

[p' SQR' q']




