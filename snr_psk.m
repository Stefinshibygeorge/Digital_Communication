N  = 10000;
bits = round(randi([0 1],N,1));
figure;
stem(bits);
xlim([0 20]);
title('Stream of bits');

BB_BPSK = pskmod(bits,2);

BER_th = [];
BER_sim = [];
for snrdb = 1:8
    recieve = awgn(BB_BPSK,snrdb);
    snr = 10.^(snrdb/10);
    thresholding = (recieve <= 0);
    BER_th = [BER_th 0.5 * erfc(sqrt(snr))];
    BER_sim = [BER_sim sum((thresholding ~= bits)/N)];
end
figure;
semilogy(BER_th);
hold on
semilogy(BER_sim);
grid on
legend('BER Theoretical','BER Observed');
hold off

