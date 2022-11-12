clc
clear all

filename = 'OSR_us_000_0016_8k.wav';
[y,Fs] = audioread(filename);
ts=1/Fs;
fs = y(:,1);
    t = 0:ts:(length(y)*ts)-ts;


S= 2*max(Fs);
fs1 =circshift(fs,1);
fs1(1)=0;

for ro=1:16

qu=0.0023;   %intervalo  reconstruido


%------------------ DIFERENCIA ------------
i=length(fs)-1;
d=fs-fs1;
% ------------ CUANTIZACIÓN --------------

for k=1:length(fs)
    q(k)=d(k)/qu;
    if q(k) <0
        q(k)=floor(q(k));
    else
        q(k)=ceil(q(k));
    end
end

% -------------------- DPCM ---------------------------
% Con retroalimentación

for k=1:length(fs)
    if abs(q(k)) <= (2^(ro-1))/2
        DPCM(k)= q(k);
    elseif abs(q(k)) > (2^(ro-1))/2
        DPCM(k)= 2^(ro-1);
    else 
        DPCM(k)= 0;
    end


%------------------ DIFERNECIA RECONSTRUIDA -------------

    if DPCM(k)<= 0
        dc(k)= (DPCM(k) * qu)+ (qu/2);
    else
        dc(k)= (DPCM(k)*qu)- (qu/2);
    end

end
%---------------    MUESTRA RECONSTRUIDA   -------------

fsc= zeros(1,length(fs));
for k=1:i
    fsc(k+1) =dc(k)+fsc(k);
end

ruido=fs1-fs;
Q=sum(ruido)/length(ruido);
% figure (ro)
% plot (fs)
% hold on
% plot(fsc)
% legend('Fs',strcat('Fs reconstruida con \rho = ', num2str(ro)))

    % Q(ro)=1/12 * q(ro)^2;
     SQR(ro)=10*log10(S/Q);
end

%[fs1' fs' d' q' DPCM' dc' fsc']

[(1:16)' SQR']