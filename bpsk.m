clc;
close all;
clearvars;

%**************************      Parameters    ****************************
A = 1;
fc = 1000;
Tc = 1/fc;
t = 0:Tc/20:Tc;
N = 1000;


%********************     BITSTREAM generation    *************************

bits = round(randi([0 1],N,1));
figure;
subplot(2,1,1)
stem(bits);
xlim([0 20]);
title('Stream of bits');



%******************     BITSTREAM NRZ generation    ***********************
nrz = 2*bits - 1;
subplot(2,1,2);
stem(nrz);
xlim([0 20]);
title('Stream of nrzbits');



%******************     BPSK SIGNAL generation      ***********************

Inphase = [];

for n = 1:N
    In = nrz(n)*A*cos(2*pi*fc*t);
    Inphase = [Inphase In];
end

figure;
plot(Inphase);
xlim([0 200]);
title('BPSK Signal');




%********************      Signal Constellation   *************************

M = 2;
constellation = [];
for n = 1:N
    if(nrz(n) == -1)
        constellation = [constellation exp(-1i*(2*pi*0)/M)];
    elseif(nrz(n) == 1)
        constellation = [constellation exp(-1i*(2*pi*1)/M)];
    end
end
scatterplot(constellation);
title('BPSK Signal Constellation');



%**TRANSMIT and RECIEVE Signals *********************
%*************************  (No Noise Channel)  ***************************


Rx_sig = Inphase;   % no noise (ideal transmittion)
Rx = [];

for i=1:N

    % ************          CORELATION RECIEVER      **********************
    Rx_in = Rx_sig((i-1)*length(t)+1:i*length(t)).*cos(2*pi*fc*t);
    Rx_in_intg = (trapz(t,Rx_in))*(2/Tc);


    % ********************     DECISION MAKER    **************************
    if(Rx_in_intg > 0) 
        out_in = 1;
    else
        out_in = 0;
    end

    Rx = [Rx out_in]
end

%***************    RECIEVED SIGNAL VIA NON NOISY CHANNEL    **************
figure;
stem(Rx);
xlim([0 20]);
title('Recieved Signal');


%**TRANSMIT and RECIEVE Signals *********************
%*************************  (AWGN Noise Channel)  *************************

noisy_signal = awgn(Rx)
