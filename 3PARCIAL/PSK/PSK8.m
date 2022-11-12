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



%Valor de a & b 
a = 0.541;
b = 1.307;


FI=[];
FQ=[];

for i=1:length(vec)
    fdn(i)=str2num(vec(i));
end

%------------------- CONVERTIDOR ------------------------------------------
inde=1;
for i=1:3:length(fdn)
         I=fdn(1,i);
         Q=fdn(1,i+1);
         C=fdn(1,i+2);
         %PARA C
         FIver(inde)= I;
         Cver (inde)=C;
         switch num2str(([I C]))
            case '0  0'
                FI=[FI, ones(1,40)*a*-1];
            case '0  1'
                FI=[FI ,ones(1,40)*b*-1];
            case '1  0'
                FI=[FI ,ones(1,40)*a];
            case '1  1'
                FI=[FI ,ones(1,40)*b];
        end
          
         %PARA C NEGADA
          C=double(not(C));
%          FQver(inde)= [Q C];
         switch num2str(([Q C]))
            case '0  1'
                 FQ=[FQ, ones(1,40)*b*-1];
            case '0  0'
                 FQ=[FQ ,ones(1,40)*a*-1];
            case '1  1'
                 FQ=[FQ ,ones(1,40)*b];
            case '1  0'
                 FQ=[FQ , ones(1,40)*a];
         end
         inde=inde+1;
end




figure(1)
tiledlayout(2,1)
nexttile
plot(fdn,'Color','#8A0868','LineWidth',1.2)
ylim([-0.1,1.2])
title('Señal digital f_n(t)')
nexttile
plot(abs(fft(fdn)),'Color','#8A0868','LineWidth',1.2)
title('F_n(\omega)')

figure(2)
tiledlayout(2,1)
nexttile
plot(FI,'LineWidth',1.3,'Color','#f59e2c')
ylim([-b-0.2,b+0.2])
title(' Salida F_I(t) del CAD ')
nexttile
plot(FQ,'LineWidth',1.3,'Color','#f59e2c')
ylim([-b-0.2,b+0.2])
title(' Salida F_Q(t) del CAD ')

%-------------------------- MODULACIÓN ------------------------------------
n=1:length(FI);
p1=sin(2*pi*n/13);
p2=cos(2*pi*n/13);


fmI=FI.*p1;
fmQ=FQ.*p2;

%FI
figure(3)
tiledlayout(3,1);
nexttile
plot(fmI,'LineWidth',1.3,'Color','#51bf30')
ylim([-b-0.2,b+0.2])
title('F_{IM}(t)')
nexttile
plot(fmI,'LineWidth',1.3,'Color','#51bf30')
xlim([0,220])
title('F_{IM}(t)')
nexttile
plot(abs(fft(fmI)),'LineWidth',1.3,'Color','#51bf30')
title('F_{IM}(\omega) modulada')


%FQ
figure(4)
tiledlayout(3,1);
nexttile
plot(fmQ,'LineWidth',1.3,'Color','#4f7082')
ylim([-b-0.2,b+0.2])
title('F_{QM}(t)')
nexttile
plot(fmQ,'LineWidth',1.3,'Color','#4f7082')
xlim([0,220])
title('F_{QM}(t)')
nexttile
plot(abs(fft(fmQ)),'LineWidth',1.3,'Color','#4f7082')
title('F_{QM}(\omega) modulada')

%-------------------------------- RUIDO -----------------------------------
s=fmQ+fmI;
r = 0.05*randn(1,length(s));
s = s+r;
figure(5)
tiledlayout(2,1);
nexttile
plot(s,'LineWidth',1.3,'Color','#e65091')
title('8-PSK(t) con \sigma=0.5')
nexttile
plot(abs(fft(s)),'LineWidth',1.3,'Color','#e65091')
title('8-PSK(\omega) con \sigma=0.5')



%-------------------- RECEPTOR--- -----------------------------------------

 % ---  DEMODULACIÓN   ---

demFI= s.*sin(2*pi*n/13);
demFQ=s.*onos(2*pi*n/13);

wc=1/8; % Frecuencia de corte del filtro debería ser menor que la portadora
[N,D] = butter(1,wc,'low');
fIrec=filter(N,D,demFI);
fQrec=filter(N,D,demFQ);

figure(6)
tiledlayout(4,1)
nexttile
plot(fIrec,'LineWidth',1.3,'Color','#bd313f')
title('F_{IM}(t) recuperada')
nexttile
plot(abs(fft(fIrec)),'LineWidth',1.3,'Color','#bd313f')
title('F_{IM}(\omega) recuperada')
nexttile
plot(fQrec,'LineWidth',1.3,'Color','#bd31bb' )
title('F_{QM}(t) recuperada')
nexttile
plot(abs(fft(fIrec)),'LineWidth',1.3,'Color','#bd31bb')
title('F_{QM}(\omega) recuperada')

%------------------------     DETECTOR  -----------------------
 fidiagrama=detectar(fIrec);
fqdiagrama=detectar(fQrec);

z=1
for i=1:2:80
   
diagramaver2(z)=fidiagrama(i+1)
diagramaver1(z)=fidiagrama(i)
 z=z+1;
end

%[diagramaver1' FIver' Cver' diagramaver2']


%FUNCIÓN PARA DETECTAR 1 & 0 
function detec = detectar(x)
k=length(x);
detec = zeros(1,(k/40));
r=1;
while(r<40)
    for j=0:20:k-20
        avera=0;
        for i=1:20
          avera= x(j+i);
        end
        avera=avera/40;
         if avera <= 0 
             detec(r)= 0;
         else
             detec(r)= 1;
         end    
        r=r+1;
    end
end
end
 


