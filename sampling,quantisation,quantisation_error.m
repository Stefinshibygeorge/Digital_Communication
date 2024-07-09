clc;
close all;
clear vars;

Vo = 10; % amplitude of signal
Vpp = 2 * Vo; % peak to peak amplitude of signal

f = 1000; % carrier frequency
fs = 8000;% sampling frequency

T = 1/f; %carrier period
Ts = 1/fs;% sampling period

nCyc = 5; % num of cycles to be displayed

%%%%-----------------------------%%%%
% Analog Time vector creation and signal genertaion
%
%analog_time vector :
% keep step as a multiple of Ts so that sampling can be easily done
% let step = Ts/10
t_analog = 0:Ts/10:T * nCyc; 

signal = Vo * sin(2*pi*f*t_analog);
figure;
subplot(3,1,1);
plot(t_analog,signal)
title('Signal')

%apply dc shifting to the signal
offset_signal = Vo + signal;
subplot(3,1,2);
plot(t_analog,offset_signal);
title('Offset signal');

%%%% Digital time vector generation and sampling process
t_dig = 0:Ts:nCyc*T;
sampled_signal = Vo * sin(2*pi*f*t_dig);
subplot(3,1,3);
stem(t,sampled_signal);
title('Sampled Signal');

%%% Quantisation process
Num_bits = 4; % 4 bit Quantisation process ie, 2^4 = 16 levels
L = 2^ Num_bits; % levels  = 2^n
step_size = Vpp/L;% difference between two levels

levels = 0:step_size:Vpp;

codebook = 0 - step_size/2 :step_size:Vpp + step_size/2;
[ind,q,distor] = quantiz(offset_signal,levels,codebook);
figure;
stem(t_analog,q);

%%% Quantisation error - SQR %%%
%
%quantise signals at different levels and keep tabulate their snr

Num_bits_arr = [2, 3, 4, 8, 16];
for i = 1 : length(Num_bits_arr)
    
    Num_bits = Num_bits_arr(i) ; 
    L = 2^ Num_bits; % levels  = 2^n
    step_size = Vpp/L;% difference between two levels

    levels = 0:step_size:Vpp;
    codebook = 0 - step_size/2 :step_size:Vpp + step_size/2;

    [ind,q,distor(i)] = quantiz(offset_signal,levels,codebook);
end

figure();
plot(Num_bits_arr,distor)
title('Qunatisation error plot')

%plot SNR values - SNR = sigal power / noise power
% signal power = sum squares of signal
% noise power = sum of squares od noise/error 
% calculate SNR and SNR_dB

signal_power = sum(signal.^2);
noise_power = distor.^2;

SNR = signal_power./noise_power;
SNR_dB = 10* log(abs(SNR));

figure;
grid on;
plot(Num_bits_arr,SNR_dB);
title('SNR (dB) plot');

figure;
semilogy(Num_bits_arr,SNR_dB);
grid on;
title('SNR (dB) plot');

figure;
semilogy(Num_bits_arr,SNR);
grid on;
title('SNR  plot on semilog');



