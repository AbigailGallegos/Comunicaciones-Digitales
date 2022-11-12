clc
close all
clear all


% -------------- SECUENCIA DE BITS - ----------
num = randperm(255,15);
numb=cellstr(dec2bin(num));
for i=1:15 %Concatenar secuencia de bits
    if i==1 || i==2
        vec=strcat(numb(1),numb(2));
    else
        vec=strcat(vec,numb(i));
    end    
end

vec=char(vec);

%-------GRÁFICA DE LA SECUENCIA GENERADA  -------------------

n=length(vec)*20;

%Valor de a
a=1/sqrt(2);

p1=sin(2*pi*n);
p2=cos(2*pi*n);
FI=[];
FQ=[];

for i=1:length(vec)
    fdn(i)=str2num(vec(i));
end


for i=1:2:length(vec)
        switch vec(1,i:i+1)
            case '11'
                FI=[FI, ones(1,20)*a];
                FQ=[FQ, ones(1,20)*a];
            case '01'
                FI=[FI ,ones(1,20)*a*-1];
                FQ=[FQ , ones(1,20)*a];
            case '00'
                FI=[FI ,ones(1,20)*a*-1];
                FQ=[FQ,ones(1,20)*a*-1];
            case '10'
                FI=[FI ,ones(1,20)*a];
                FQ=[FQ,ones(1,20)*a*-1];
        end
 end

figure(1)
tiledlayout(5,1)
nexttile
plot(fdn)
ylim([-0.1,1.2])
title('Señal digital f_n(n)')
nexttile
plot(fdn)
xlim([0,8])
title(strcat('Fragmento de secuencia: ',vec(1,1:8)))

nexttile
plot(FI)
xlim([0,200])
ylim([-1.2,1.2])
title('f_I(n)')

nexttile  
plot(FQ)
xlim([0,200])
ylim([-1.2,1.2])
title('f_Q(n)')

FDN=fft(fdn);
nexttile;
plot(abs(FDN),'Color','#8A0868');
title('F_n(\omega)')


%------------------ MODULACIÓN Y RUIDO ------------------------------------
n=1:length(vec)*10;
FIm= sin(2*pi*n/13).*FI;
FQm=cos(2*pi*n/13).*FQ;
especI=fft(FIm);
especQ=fft(FQm);


 Y=(FIm+FQm)+randn(1,1200)*0.2;
 
 especY=fft(Y);

figure(2)
tiledlayout(3,1)
nexttile
plot(FIm)
title('f_I(n) modulada')
nexttile
plot(FIm)
xlim([0,200])
nexttile
plot(FQm)
plot(abs(especI))
title(' Espectro F_I( \omega) ')



figure(3)
tiledlayout(3,1)
nexttile
plot(FQm)
title('f_Q(n) modulada')
nexttile
plot(FQm)
xlim([0,200])
nexttile
plot(abs(especQ),'Color','#8A0868')



figure(4)
tiledlayout(3,1)
nexttile
plot(Y)
title('4 PSK')
nexttile
plot(Y)
xlim([0,200])
nexttile
plot(abs(especY),'Color','#8A0868')

%------------------------ DEMODULACIÓN ------------------------------------
demFI= Y.*sin(2*pi*n/13);
demFQ=Y.*cos(2*pi*n/13);


figure(5)
tiledlayout(2,1)
nexttile
plot(abs(fft(demFI)),'Color','#8A0868')
title('F_I(\omega)')
nexttile
plot(abs(fft(demFQ)),'Color','#8A0868')
title('F_Q(\omega)')


%----------------------------- FILTRADO -----------------------------------
wc=1/8; % Frecuencia de corte del filtro debería ser menor que la portadora
[N,D] = butter(1,wc,'low');
fIrec=filter(N,D,demFI);
fQrec=filter(N,D,demFQ);


figure(6)
tiledlayout(2,1)
nexttile
plot(fIrec)
title('F_I(t)')
nexttile
plot(fQrec)
title('F_Q(t)')

Frec=fIrec+fQrec;


%-------------------------DIAGRAMA DE CONSTELACIÓN ------------------------
fidiagrama=detectar(fIrec);
fqdiagrama=detectar(fQrec);

figure(7)
    plot(fIrec, fQrec, '.', 'markersize', 20,'Color','#F7D358')
title('Diagrama de constelación');
% 
vecplot=[];
 vecrec=[];
 for i=1:60
     vecrec=[vecrec fidiagrama(i) fqdiagrama(i)];
 end
 for i=1:120
    vecplot=[vecplot str2double(vec(i))];
 end

%-----------------------------DETECTAR-------------------------------------


figure(8)
stem(vecplot,'LineWidth',3,'MarkerFaceColor','#86B404','MarkerEdgeColor','#86B404','Color','#86B404')
hold on 
stem(vecrec,'LineWidth',1,'MarkerFaceColor','#F7819F', 'MarkerEdgeColor','#F7819F','Color',"#F7819F")
title ('Señal recuperada')
ylim([-0.1,1.2])
legend('Original', 'Recuperada')


%FUNCIÓN PARA DETECTAR 1 & 0 
function detec = detectar(x)
k=length(x);
detec = zeros(1,(k/20));
r=1;
while(r<60)
    for j=0:20:k-20
        avera=0;
        for i=1:20
          avera= x(j+i);
        end
        avera=avera/20;
         if avera <= 0 
             detec(r)= 0;
         else
             detec(r)= 1;
         end    
        r=r+1;
    end
end
end
 


