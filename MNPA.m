%{
Author: Maharshi Gurjar 
ELEC 4700 MNA Building
%}
clc; close all; clear;
set(0, 'DefaultFigureWindowStyle', 'docked')
%a) DC
%Generate MNA Matrix
G = [1/1 -1/1 0 0 0 1 0 0 ; 
    -1/1 (1/1+1/2) 0 0 0 0 1 0; 
    0 0 1/10 0 0 0 -1 0;
    0 0 0 1/0.1 -1/0.1 0 0 1;
    0 0 0 -1/0.1 (1/0.1+1/1000) 0 0 0;
    1 0 0 0 0 0 0 0;
    0 1 -1 0 0 0 0 0;
    0 0 (-100/10) 1 0 0 0 0
    ];

C = [0.25 -0.25 0 0 0 0 0 0;
    -0.25 0.25 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 -0.2 0;
    0 0 0 0 0 0 0 0];

F = zeros(8,1);
% 2A DC Sweep
vin = linspace(-10,10,50);
vout = zeros(50,1);
v3 = zeros(50,1);
for i = 1:length(vin)
    F(6) = vin(i);
    V = G\F;
    v3(i) = V(3);
    vout(i) = V(5);
end
%Plot the DC vin and vout @ vout
figure(1)
plot(vin,vout)
xlabel('Vin (V)')
ylabel('Vout (V)')
title('DC Case @ Vout')
axis tight
grid on;
%Plot the DC vin and vout @ V3
figure(2)
plot(vin,v3)
xlabel('Vin (V)')
ylabel('V3 (V)')
title('DC Case @ V3')
axis tight
grid on;

%b) AC 

w = 2*pi* linspace(0,50,1000); 
vout = zeros(1000,1);
gain = zeros(1000,1);

for n = 1:1000
    s = 1i*w(n);
    A = G + (s.*C) ;
    V = A\F;
    vout(n) = abs(V(5)); 
    gain(n) = 20*log10(abs(vout(n))/abs(V(1)));
end
%Plot the transient analysis
figure(3);
plot(w,vout)
xlabel('Frequency (Hz)')
ylabel('Vout (V)')
title('AC Case @ Vout')
grid on;
%plot AC gain in dB
figure(4)
plot(w,gain)
xlabel('Frequency (Hz)')
ylabel('Gain (dB)')
title('AC Gain')
axis tight;
set(gca,'XScale','log');
grid on; 

%c) Pertubations of C

figure(5);
vout = zeros(1000,1);
gain = zeros(1000,1);

for n=1:1000
    p = 0.05*randn();
    C(1, 1)= 0.25*p;
    C(2, 2)= 0.25*p;
    C(1, 2)= -0.25*p;
    C(2, 1)= -0.25*p;
    s = 2*pi;
    A = G + (s.*C) ;
    V = A\F;
    vout(n) = abs(V(5)); 
    gain(n) = 20*log10(abs(vout(n))/abs(V(1)));
end
histogram(gain,100);
title('Gain (Random C)');
xlabel('Gain (dB)');
ylabel('Counts');
axis tight;
grid on;