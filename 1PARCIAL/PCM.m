clc
clear all

fs = [1 0.8 0.6 0.4 0.2 0.01 -0.2 -0.4 -0.6 -0.8 -1 -0.8 -0.6 -0.4 -0.2 0.001 0];
fs1=circshift(fs,1);

S=bandpower(fs);
for ro=1:16
qu=0.023;


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

% -------------------- DPCM ------------------------% 
% Con retroalimentación

for k=1:length(fs)
    if abs(q(k)) <= (2^(ro-1) )/2
        DPCM(k)= q(k);
    elseif abs(q(k)) > (2^(ro-1))/2
        DPCM(k)= 2^(ro-1);
    else 
        DPCM(k)= 0;
    end
end



%------------------ DIFERNECIA RECONSTRUIDA -------------

for k=1:length(fs)
    if DPCM(k)<0
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
fsc(1)=dc(1);

ruido= fsc-fs1;

% figure (ro)
% plot (fs1)
% hold on
% plot(fsc)
% hold on
% plot(ruido)
% grid("on")
% legend('Fs','Fs reconstruida','Ruido')





Q=bandpower(ruido);


% for k=1:6
%     Q(k)=1/12 * q(k)^2;
%     SQR(k)=10*log10(S./Q(k));
% end

SQR(ro)= 10*log10(S/Q);

end
[[1:16]' SQR']


%[fs1' fs' d' q' DPCM' dc' fsc' ]