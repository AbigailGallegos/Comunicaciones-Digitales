clc
clear all
close all


M=256;
n=1:M;
miu=0.01;
fn= cos(2*pi*n/28);
fn1=0.1*sin(2*pi*n/4);

dn= fn+fn1;

ha= dsp.LMSFilter('Length',15,'Method','LMS','StepSize',miu);
[y,e] = ha(fn',dn');

yn=filter(y,e,fn1);

err=dn+yn;

figure(1)
tiledlayout(2,1)
nexttile
plot(fn,'LineWidth',3,'Color','#7d9bad')
hold on 
plot(err,'LineWidth',1.5,'Color','#f54c54')
legend('f_n','e')
title('Gráfica de f_n(t) vs \epsilon(x)')
nexttile
plot(dn,'LineWidth',3,'Color','#7d9bad')
hold on 
plot(err,'LineWidth',1.5,'Color','#f54c54')
legend('dn','e')
title('Gráfica de d_n(t) vs \epsilon(x)') 

%--------------- SEGUNDA GRÁFICA ----------------------------

M=1000;
n=1:M;
fn= cos(2*pi*n/28);
fn1=0.3*sin(2*pi*n/4);
dn= fn+fn1;

yn=filter(y,e,fn1);
err=dn+yn;

figure(2)
tiledlayout(2,1)
nexttile
plot(fn,'LineWidth',3,'Color','#7d9bad')
hold on 
plot(err,'LineWidth',1.5,'Color','#f54c54')
legend('f_n','e')
title('Gráfica de f_n(t) vs \epsilon(x)')
nexttile
plot(dn,'LineWidth',3,'Color','#7d9bad')
hold on 
plot(err,'LineWidth',1.5,'Color','#f54c54')
legend('dn','e')
title('Gráfica de d_n(t) vs \epsilon(x)') 
