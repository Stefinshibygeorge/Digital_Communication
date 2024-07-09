clc;
close all;
clear vars;

%bitstream generation
N = 20000;
bits = round(randi([0 1],N,1));
figure;
subplot(2,1,1);
stem(bits);
xlim([0 20]);
title('Bits');

% convert to nrz values ie, 1 --> 1 and 0 --> -1.....
% use 2*bits - 1
%that is,
% 2*1 - 1 = 1 (1 --> 1)
% 2*0 - 1 = -1 (0 --> -1)

nrz_bits = 2*bits - 1;
subplot(2,1,2);
stem(nrz_bits);
xlim([0 20]);
title('NRZ Bits');

% reshape the nrz_bits (N*1)into a (2*N/2) matrix
%  _       _
% |........ | ---> inshape
% |_       _| ---> quadphase

reshaped_bits = reshape(nrz_bits,2,N/2);

fc = 1000;
Tc = 1/fc;
Ncyc = 1;

t = 0:Tc/20:Ncyc * Tc;

inphase = [];
quadphase = [];
modulated_signal = [];

for n = 1:N/2
    inphase = [inphase , reshaped_bits(1,n).*cos(2*pi*fc*t)];
    quadphase = [quadphase , reshaped_bits(2,n).*sin(2*pi*fc*t)];
    modulated_signal = [modulated_signal reshaped_bits(1,n).*cos(2*pi*fc*t) + reshaped_bits(2,n).*sin(2*pi*fc*t)];
end

figure;
subplot(2,2,1);
plot(inphase);
xlim([0 200])
title('inphase');

subplot(2,2,2);
plot(quadphase);
xlim([0 200])
title('quadphase');

subplot(2,2,[3,4]);
plot(modulated_signal);
xlim([0 200])
title('modulated signal');


%signal constellation
constellation = [];
M = 4;
for n = 1:N/2
    if (reshaped_bits(1,n) == -1 && reshaped_bits(2,n) == -1)
        constellation = [constellation exp(-1i*2*pi*0/M)];
    elseif (reshaped_bits(1,n) == -1  && reshaped_bits(2,n) == 1)
         constellation = [constellation exp(-1i*2*pi*1/M)];
    elseif (reshaped_bits(1,n) == 1 && reshaped_bits(2,n) == -1)
         constellation = [constellation exp(-1i*2*pi*2/M)];
    elseif (reshaped_bits(1,n) == 1 && reshaped_bits(2,n) == 1)
         constellation = [constellation exp(-1i*2*pi*3/M)];
    end
end

figure;
plot(constellation);
title('signal constellation');
scatterplot(constellation);

%adding noise

snrdb = 10;
recieved_signal = awgn(modulated_signal,snrdb);

% reciever
Rx_mod = [];

for n = 1:N/2
    Rx = recieved_signal( (n-1)*length(t) + 1 : n*length(t) );

    Rx_intg = 2/Tc * trapz(t,Rx.*cos(2*pi*fc*t));
    if (Rx_intg > 0)
        Rx_inphase = 1;
    else
        Rx_inphase = 0;
    end

    Rx_intg = 2/Tc * trapz(t,Rx .* sin(2*pi*fc*t));
    if (Rx_intg > 0)
        Rx_quadphase = 1;
    else
        Rx_quadphase = 0;
    end
    Rx_mod = [Rx_mod Rx_inphase Rx_quadphase];
end

figure;
stem(Rx_mod);
xlim([0 20]);
title('Recieved Signal');

% BER Calculation
ber_th = [];
ber_sim = [];

for snrdb = 1:12
    
    snr = 10 .^ (snrdb/10);
    thresh_in = awgn(reshaped_bits(1,:),snrdb) <= 0;
    thresh_quad = awgn(reshaped_bits(2,:),snrdb) <= 0;

    ber_in = sum(reshaped_bits(1,:) == thresh_in)/N;
    ber_quad = sum(reshaped_bits(2,:) == thresh_quad)/N;

    ber_sim = [ber_sim mean([ber_in ber_quad])];
    ber_th = [ber_th 0.5*erfc(sqrt(snr))];
end

snr_db = 1:12;
figure;
grid on;
semilogy(snr_db , ber_sim);
hold on;
semilogy(snr_db,ber_th);









