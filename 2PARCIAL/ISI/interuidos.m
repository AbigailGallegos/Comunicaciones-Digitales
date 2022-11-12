clc
close all
clear all
%------------ FUNCIÓN SAMPLING  --------------
n=1:50;
ft=sinc(2*(n-15)/10);
figure(1)
tiledlayout(2,1)
% Top plot
nexttile
stem(ft,'filled')
title('Función Sampling')

k=100;
n=1:k;
nexttile
fn=zeros(1,k);
plot(fn)
for i=1:10:k
    a=(i-1)/10;
    if mod (a,2) == 0 % Si es par, mandará un 0
      fn= fn-sinc(2*(n-15-i+1)/10);
      x=-sinc(2*(n-15-i+1)/10);
      hold on
      plot(x,'Color',[0,0.7,0.9])
    else % Si es impar, mandará un 1
      fn= fn+sinc(2*(n-15-i+1)/10); 
       x=sinc(2*(n-15-i+1)/10); 
       hold on
     plot(x,'Color',[0,0.7,0.9])
    end
end
hold on
plot(fn,'LineWidth',2,'MarkerEdgeColor','k')
title('Tren construido')


%----------------  GRÁFICA TREN DE BITS   -------------------

for i=1:10:k
    a=(i-1)/10;
    if mod (a,2) == 0 % Si es par, mandará un 0
      fn= fn-sinc(2*(n-15-i+1)/10);
      x=-sinc(2*(n-15-i+1)/10);
      hold on
      plot(x)
    else % Si es impar, mandará un 1
      fn= fn+sinc(2*(n-15-i+1)/10); 
       x=sinc(2*(n-15-i+1)/10); 
       hold on
      plot(x)
    end
end

% -------------- SECUENCIA DE BITS - ----------
num = randperm(255,15);
numb=cellstr(dec2bin(num));
for i=1:15 %Concatenar secuencia de bits
    if i==1 || i==2
        vec=strcat(numb(1),numb(2));
    else
        vec= strcat(vec,numb(i));
    end    
end

vec=char(vec);

%-------------   GRÁFICA SECUENCIA DE BITS    ------------
vec=char(vec);
for i=1:length(vec)
    dig(i)=str2double(vec(i));
end


figure(2)
tiledlayout(2,1)
nexttile
stem(dig,'filled')
title('Señal digital')
ylim([0.00 1.20])


%-------GRÁFICA DE LA SECUENCIA GENERADA  -------------------


k=length(vec)*10;
fdn=zeros(1,k);
n=1:k;
nexttile
plot(fdn)
for i=1:length(vec)
    if vec(i) == '0' % Mandará un 0
      fdn= fdn-sinc(2*(n-5-(i*10))/10);
    else % Mandará un 1
      fdn= fdn+sinc(2*(n-5-(i*10))/10); 
    end
end
plot(fdn)
title('Sampling señal digital')


%Ruido agregado a la señal
ruido1= fdn+ randn(1,k)*0.5;
ruido2= fdn+ randn(1,k)*0.8;
ruido3 = fdn+ randn(1,k)*1.2;

%----------------- DIAGRAMA DE OJO SIGMA = 0 ------------------------------

k=length(fdn);
ojo=zeros(1,40);
figure(3)
tiledlayout('flow')
nexttile

for j=1:40:k
    for i=1:40
        ojo(i)=fdn(j+i-1);   
    end
    hold on
    plot(ojo)
end

title('Diagrama de ojo \sigma = 0')

%----------------- DIAGRAMA DE OJO SIGMA = 0.5 ----------------------------
k=length(fdn);
nexttile
for j=1:40:k
    for i=1:40
        ojo(i)=ruido1(j+i-1);   
    end
    hold on
    plot(ojo)
end
title('Diagrama de ojo \sigma = 0.5')


%----------------- DIAGRAMA DE OJO SIGMA = 0.8 ----------------------------

nexttile
for j=1:40:k
    for i=1:40
        ojo(i)=ruido2(j+i-1);   
    end
    hold on
    plot(ojo)
end
title('Diagrama de ojo \sigma = 0.8')

%----------------- DIAGRAMA DE OJO SIGMA = 1.2 ----------------------------

nexttile
for j=1:40:k
    for i=1:40
        ojo(i)=ruido3(j+i-1);   
    end
    hold on
    plot(ojo)
end
title('Diagrama de ojo \sigma = 1.2')


%--------------------------  DETECTOR -------------------------------------


k=length(fdn);

y1=convD(fdn,dig,1);
y2=convD(ruido1,dig,1);
y3=convD(ruido2,dig,1);
y4=convD(ruido3,dig,1);

figure (4)
tiledlayout('flow')
nexttile
stem(y1,'MarkerFaceColor','#0072BD', 'MarkerEdgeColor','#0072BD')
hold on 
stem(dig,'LineWidth',1,'MarkerFaceColor','#D95319','MarkerEdgeColor','#D95319')
legend('Original','Detectada')
title('Señal detectada \sigma = 0')
ylim([-0.3,1.3])
nexttile
stem(y2,'LineWidth',1,'MarkerFaceColor','#0072BD','MarkerEdgeColor','#0072BD')
hold on 
stem(dig,'LineWidth',1,'MarkerFaceColor','#D95319','MarkerEdgeColor','#D95319')
legend('Original','Detectada \sigma = 0.5')
title('Señal detectada \sigma = 0.5')
ylim([-0.3,1.3])
nexttile
stem(y3,'LineWidth',1,'MarkerFaceColor','#0072BD','MarkerEdgeColor','#0072BD')
hold on 
stem(dig,'LineWidth',1,'MarkerFaceColor','#D95319', 'MarkerEdgeColor','#D95319')
legend('Original','Detectada')
title('Señal detectada \sigma = 0.8')
ylim([-0.3,1.3])
nexttile
stem(y4,'LineWidth',1,'MarkerFaceColor','#0072BD','MarkerEdgeColor','#0072BD')
hold on 
stem(dig,'LineWidth',1,'MarkerFaceColor','#D95319','MarkerEdgeColor','#D95319')
legend('Original','Detectada')
title('Señal detectada \sigma = 1.2')
ylim([-0.3,1.3])

%---------------- FILTRO ACOPLADO -----------------------------------------

nf=1:21;  %Para 20 muestras 
san1 = sinc(2*(nf-15)/10);
figure (5)
tiledlayout(2,1)
nexttile
stem(san1,'filled')
title('Filtro acoplado')


%------------------ DESPLAZAMIENTO 20 UNIDADES ----------------------------

k=length(vec)*20;
fdn2=zeros(1,k);
n=1:k;
for i=1:length(vec)
    if vec(i) == '0' % Mandará un 0
      fdn2= fdn2-sinc(2*pi*(n-5-(i*20))/31.4);
    else % Mandará un 1
      fdn2= fdn2+sinc(2*pi*(n-5-(i*20))/31.4); 
    end
end
nexttile
plot(fdn2)
title('Sampling señal digital desplazada 20 unidades')

san1=[san1 zeros(1,(length(fdn)-20))];

%Ruido agregado a la señal
ruidoSa1= fdn2+ randn(1,k)*0.5;
ruidoSa2= fdn2+ randn(1,k)*0.8;
ruidoSa3 = fdn2+ randn(1,k)*1.2;

%------------- SEÑAL g(n) -------------------

 gn = conv(san1, fdn2, 'same'); 
 gn1 = conv(san1, ruidoSa1, 'same');
 gn2 = conv(san1, ruidoSa2, 'same'); 
 gn3 = conv(san1, ruidoSa3, 'same'); 
   



figure(6)
tiledlayout('flow')
nexttile
    plot(gn)
    title("g(n) con \sigma = 0");
    xlim([-1,1250])
nexttile
    plot(gn1);
    title("g(n) con \sigma = 0.5");
    xlim([-1,1250])
nexttile
    plot(gn2);
    title("g(n) con \sigma = 0.8");
    xlim([-1,1250])
nexttile
    plot(gn3);
    title("g(n) con \sigma = 1.2");
    xlim([-1,1250])




%----------------- DIAGRAMA DE OJO SIGMA = 0 ------------------------------
k=length(fdn2);
ojo2=zeros(1,40);
figure(7)
tiledlayout(4,1)
nexttile
for j=1:80:k
    for i=1:80
        ojo2(i)=fdn2(j+i-1);   
    end
    hold on
    plot(ojo2)
end
title('Diagrama de ojo \sigma = 0')

nexttile
for j=1:80:k
    for i=1:80
        ojo2(i)=ruidoSa1(j+i-1);   
    end
    hold on
    plot(ojo2)
end
title('Diagrama de ojo \sigma = 0.5')
nexttile

for j=1:80:k
    for i=1:80
        ojo2(i)=ruidoSa2(j+i-1);   
    end
    hold on
    plot(ojo2)
end
title('Diagrama de ojo \sigma = 0.8')

nexttile
for j=1:80:k
    for i=1:80
        ojo2(i)=ruidoSa3(j+i-1);   
    end
    hold on
    plot(ojo2)
end
title('Diagrama de ojo \sigma = 1.2')

%---------------------- SEÑAL DETECTADA FILTRO ----------------------------

yf1=convD(gn,dig,2);
yf2=convD(gn1,dig,2);
yf3=convD(gn2,dig,2);
yf4=convD(gn3,dig,2);



figure (8)
tiledlayout(4,1)
nexttile
stem(yf1,'MarkerFaceColor','#0072BD', 'MarkerEdgeColor','#0072BD')
hold on 
stem(dig,'LineWidth',1,'MarkerFaceColor','#D95319','MarkerEdgeColor','#D95319')
legend('Original','Detectada')
title('Señal detectada \sigma = 0')
ylim([-0.3,1.3])
nexttile
stem(yf2,'LineWidth',1,'MarkerFaceColor','#0072BD','MarkerEdgeColor','#0072BD')
hold on 
stem(dig,'LineWidth',1,'MarkerFaceColor','#D95319','MarkerEdgeColor','#D95319')
legend('Original','Detectada \sigma = 0.5')
title('Señal detectada \sigma = 0.5')
ylim([-0.3,1.3])
nexttile
stem(yf3,'LineWidth',1,'MarkerFaceColor','#0072BD','MarkerEdgeColor','#0072BD')
hold on 
stem(dig,'LineWidth',1,'MarkerFaceColor','#D95319', 'MarkerEdgeColor','#D95319')
legend('Original','Detectada')
title('Señal detectada \sigma = 0.8')
ylim([-0.3,1.3])
nexttile
stem(yf4,'LineWidth',1,'MarkerFaceColor','#0072BD','MarkerEdgeColor','#0072BD')
hold on 
stem(dig,'LineWidth',1,'MarkerFaceColor','#D95319','MarkerEdgeColor','#D95319')
legend('Original','Detectada')
title('Señal detectada \sigma = 1.2')
ylim([-0.3,1.3])






%FUNCIÓN PARA DETECTAR 1 & 0 
function y = convD(x,dig,num)
 k=length(x);
detectada= zeros(1,length(dig));
jj=1;
while(jj<length(dig))
    for i=15:10*num:k
         detectada(jj)= x(i-1);
         jj=jj+1;
    end
end

    for i=1:length(detectada)
        if detectada(i) >= 0
            y(i)=1;
        else
            y(i)=0;
        end
    end
end








