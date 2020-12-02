function [amplitudes,delta,theta,alpha,F]=fourier(analisis)

X=analisis;
L=length(X);
Y = fft(X);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;
F=1:13;
% %plot(f,P1)
amplitudes=P1(1:13);

delta=sum(P1(1:3))/3;
theta=sum(P1(4:7))./4;
alpha=sum(P1(8:13))./6;
% % title(['Frecuencias, Amplitudes Evento ',num2str(i)])
% % xlabel('f (Hz)')
% % ylabel('|P1(f)|')