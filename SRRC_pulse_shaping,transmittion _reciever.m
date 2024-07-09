clc;
close all;
clear vars;

% signal generation / bit stream genration [1,0,0,....]
N = 1000;
bits = round(randi([0 1],1,N));
figure;
subplot(2,1,1);
stem(bits);
xlim([0 20]);
title('Bit Stream');

% upsample (to cop up with delay and to match filter freq response)
rate = 8;
upsampled_bits = upsample(bits,rate); % padd 7 zeros after every bit in the bitstream
subplot(2,1,2);
stem(upsampled_bits);
xlim([0 20]);
title('Upsampled Bit Stream');

%The bits are passed through a transmitter - a matched filter transmitter
% Lets design a square root raised cosine filter 
%parameters :
beta = 0.6; % roll off factor in freq response 
sps = rate; % bits  per symbol --> 8 bits are used (padded 7 zeros)
span = 2*rate;
p = rcosdesign(beta,span,sps);

% p returns time domain representation of filter
figure;
subplot(2,2,1);
plot(p);
title('h(t)')

% find the bode plot / frequency respose
[value,frequency] = freqz(p);
subplot(2,2,2);
plot(frequency,value);
title('frequency response')

% frequence response in omega and gain dB
subplot(2,2,3);
value_db = mag2db(abs(value));
omega = frequency/pi;
plot(omega,value_db); % frequence response in omega and gain dB
title('freq resp - omega dB plot')
subplot(2,2,4);
grid on;
semilogy(omega,value_db);% frequence response in omega and gain dB in semilog
title('semilog frequency response - omega dB plot')

% thus , output = input convolved with p
tx = conv(p,upsampled_bits);

figure;
subplot(2,1,1);
plot(tx);
xlim([0 500]);
title('Pulse shaped transmitted signal');

% if no noise , rx = tx
% if noise , rx = tx + awgn

%adding noise to channel 
snr  = 20;
rx = tx + awgn(tx,snr);
subplot(2,1,2);
plot(rx);
xlim([0 500]);
title('Pulse shaped recieved signal');

%plot eye diagram
eyediagram(tx,2*sps);
eyediagram(rx,2*sps);

%plot eyediagram for different roll off values / beta values
beta_arr = [0.1,0.3,0.5,0.7,0.9];
for i = 1:length(beta_arr)
    beta = beta_arr(i);
    p_arr = rcosdesign(beta,span,sps);
    tx = conv(p_arr,upsampled_bits);
    eyediagram(tx,2*sps);
end


%Reciever is a matched filter,matched to the conjugate of transmitter
Reciever = conj(p);

% Reciever(t)
figure;
subplot(2,2,1);
plot(Reciever);
title('Reciever(t)')

% find the bode plot / frequency respose
[value,frequency] = freqz(Reciever);
subplot(2,2,2);
plot(frequency,value);
title('frequency response')

% frequence response in omega and gain dB
subplot(2,2,3);
value_db = mag2db(abs(value));
omega = frequency/pi;
plot(omega,value_db); % frequence response in omega and gain dB
title('freq resp - omega dB plot')
subplot(2,2,4);
grid on;
semilogy(omega,value_db);% frequence response in omega and gain dB in semilog
title('semilog frequency response - omega dB plot');


% The output is convolution of Reciever(t) with rx
recieved_bits = conv(Reciever,rx);

%downsample
filtdelay = (length(p)-1)/2 ;
downsampled_bits = downsample(recieved_bits,(filtdelay / rate)); %rate = 8 (upsampling was done at this rate)

%recieved_bits
output_bits = recieved_bits(2*filtdelay+1 : rate : end - (2*filtdelay));
output_bits = abs(round(output_bits,0));
output_bits = output_bits ./ 2;

figure;
stem(output_bits);
xlim([0 20]);
title('Output bits')

figure;
subplot(2,1,1);
stem(bits);
xlim([0 20]);
subplot(2,1,2);
stem(output_bits);
xlim([0 20]);






