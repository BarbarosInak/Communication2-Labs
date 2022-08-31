%% Barbaros ÝNAK
%%  1. 

Fs=27000;

Rb=18000;

%%  2.

m=randi(4,[1,1000]);

for i=1:length(m)
   if m(i)==4
       m(i)=3;
   elseif m(i)==3
       m(i)=1;
   elseif m(i)==2
       m(i)=-1;
   else
       m(i)=-3;
   end
end

%% 3.

Tb=1/Rb;

Rs=Rb/2;

Tb=Fs/Rs;

%% 4.

filter1=rcosdesign(0,10,Tb);

filter2=rcosdesign(0.5,10,Tb);

filter3=rcosdesign(1,10,Tb);

%% 5.

fft_filter1=fftshift(abs(fft(filter1))/length(filter1));
fft_filter2=fftshift(abs(fft(filter2))/length(filter2));
fft_filter3=fftshift(abs(fft(filter3))/length(filter3));

t=linspace(-1/1800,1/1800,length(filter1));
f_vector=linspace(-Fs/2,Fs/2,length(filter1));

figure;
subplot(2,3,1);
plot(t,filter1);
ylabel('Amp.');
xlabel('Time(s)');
title('Beta 0');

subplot(2,3,2);
plot(t,filter2);
ylabel('Amp.');
xlabel('Time(s)');
title('Beta 0.5');

subplot(2,3,3);
plot(t,filter3);
ylabel('Amp.');
xlabel('Time(s)');
title('Beta 1');

subplot(2,3,4);
plot(f_vector,fft_filter1);
ylabel('Amp.');
xlabel('Frequency(f)');
title('Beta 0 FFT');

subplot(2,3,5);
plot(f_vector,fft_filter2);
ylabel('Amp.');
xlabel('Frequency(f)');
title('Beta 0.5 FFT');

subplot(2,3,6);
plot(f_vector,fft_filter3);
ylabel('Amp.');
xlabel('Frequency(f)');
title('Beta 1 FFT');


%% 6.

tx_1=upfirdn(m,filter1,Tb);
tx_2=upfirdn(m,filter2,Tb);
tx_3=upfirdn(m,filter3,Tb);

%% 7.

SNR=20;

tx_noise1=awgn(tx_1,SNR);
tx_noise2=awgn(tx_2,SNR);
tx_noise3=awgn(tx_3,SNR);

%% 8.

yout1=upfirdn(tx_noise1,filter1,1,Tb);
yout2=upfirdn(tx_noise2,filter2,1,Tb);
yout3=upfirdn(tx_noise3,filter3,1,Tb);

%% 9.

yout1=yout1(10:end-11);
yout2=yout2(10:end-11);
yout3=yout3(10:end-11);

%% 10.

eyediagram(yout1,Tb,1/Fs,0);
title('Beta 0');

eyediagram(yout2,Tb,1/Fs,0);
title('Beta 0.5');

eyediagram(yout3,Tb,1/Fs,0);
title('Beta 1');
