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

%Valor de a & b 
a = 0.541;
b = 1.307;

p1=sin(2*pi*n);
p2=cos(2*pi*n);

FI=[];
FQ=[];

for i=1:length(vec)
    fdn(i)=str2num(vec(i));
end

for i=1:3:length(vec)
         vec(1,i:i+2)
         c=vec(1,1+2)
 end
