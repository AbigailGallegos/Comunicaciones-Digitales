close all
clear all 

%Tiempo
ts=[1/100 , 1/35 , 1/30 , 1/25 , 1/20 , 1/15 , 1/10 , 1/8];
n=800;

for i=1:length(ts)
    t=0.0001:ts(i):2;
   

    %SEÑALES MUESTREADAS 

    %f1= sin(2*pi*10*t); %Tiempo contínuo
    %f1= sin(2*pi*20*t); 
    f1= sin(2*pi*30*t);
    

    % TRANSFORMADA DE FOURIER DE LAS SEÑALES

    F1=0;
    %F2=0;
    %F3=0;
  
    F1=fft(f1,1/ts(i));

    invFI=ifft(F1);
    w= linspace(-25*pi,25*pi,1/ts(i));



    figure(i)
    tiledlayout('flow')
    % Top plot
    nexttile
    plot(t,f1)
    title(strcat('f(t) con ts= ',num2str(ts(i))))
    grid on
    xlabel('t [s]')
    
    % Bottom plot
    nexttile
    plot(w/(2*pi),abs(F1))
    title('Transformada de Fourier')
    grid on
    xlabel('w [Hz]')
    
    t=linspace(0.0001,2,1/ts(i));
    % Top plot
    nexttile
    plot(t,invFI)
    title('Señal recuperada')
    grid on
    xlabel('t [s]')
end

