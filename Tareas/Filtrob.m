clc
close all;

for i=1:40
    if i <10 ||  (i>=20 && i<=30)
        fn(i)=1;
    else
        fn(i)=0;
    end
end

[N,D] = butter(1,0.2,'low');
gn=filter(N,D,fn);

figure(1)
tiledlayout(2,1);
nexttile
stem(fn,'filled')
title('Señal original')
ylim([-0.3 , 1.2])
nexttile
stem(gn,'filled')
title('Señal a la salida del filtro')
ylim([-0.3 , 1.2])
