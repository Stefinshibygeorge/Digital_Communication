clc;
close all;
clearvars;


Vo = 2;
Vpp = 2*Vo;
fc = 1000;

t = 0:Tc/20:5*Tc;
signal = Vo * sin(2*pi*fc*t);
plot(t,signal);
title('Signal');


off_signal = Vo + signal;
figure;
plot(t,off_signal);
title('Offset Siganl');

L = 4;
QuantisationLevels = 0 : Vpp/L : Vpp;  
codebook = -Vpp/(2*L) : Vpp/L : Vpp + Vpp/(2*L) ;
[ind,q,distor]=quantiz(off_signal,QuantisationLevels,codebook);
figure;
stem(q);
title('Quantised Signal');



