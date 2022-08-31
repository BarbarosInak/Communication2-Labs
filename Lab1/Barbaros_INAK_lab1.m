%% 1.1 Sampling
%% a) Construction
clc;
close all;
clear;

fs= 5000;
A=[1,3,2];
f=[60,20,150];
theta=[0,pi/2,pi/4];
C=3;

t=linspace(0,0.2,1000);

x=zeros(1,length(t));

for i = 1:C
    x=x+A(i)*sin(2*pi*f(i)*t+theta(i));
end

figure;
plot(t,x);
ylabel('Amplitude');
xlabel('Time(s)');
title('x');

%% b) Downsampling
 xs1=zeros(1,length(t)/10);
 xs2=zeros(1,length(t)/20);
 a=1;
 b=1;
for i= 1:10:length(t)
    xs1(a)=x(i);
    a=a+1;
end

for i = 1:20:length(t)
    xs2(b)=x(i);
    b=b+1;
end

%% c) Plotting downsampled signals

figure;
subplot(2,1,1);
stem(linspace(0,0.2,100),xs1);
ylabel('Amplitude');
xlabel('Time(s)');
title('xs1');

subplot(2,1,2);
stem(linspace(0,0.2,50),xs2);
ylabel('Amplitude');
xlabel('Time(s)');
title('xs2');

%% d) FFT

% I decided the frequency axis according to the sampling freuency, due to
% the nyquiest theorem. According to nyquiest theorem when fs >= 2w(max
% freq component) we can reconstruct the original signal. The span of 
% frequencies are only about from -fs/2 to fs/2.

% We normalized the spectrum for conserving the energy in the frequency
% domain too.

N1=length(xs1);
N2=length(xs2);

fs1=500;
fs2=250;

f_v1=linspace(-fs1/2,fs1/2,N1);
f_v2=linspace(-fs2/2,fs2/2,N2);

fft_xs1=fftshift(abs(fft(xs1,N1))/N1);
fft_xs2=fftshift(abs(fft(xs2,N2))/N2);

figure;
subplot(2,1,1);
plot(f_v1,fft_xs1);
ylabel('Amplitude');
xlabel('Frequency(Hz)');
title('XS1');

subplot(2,1,2);
plot(f_v2,fft_xs2);
ylabel('Amplitude');
xlabel('Frequency(Hz)');
title('XS2');

%% e) Interpolation

t1=linspace(0,0.2,length(xs1));
t2=linspace(0,0.2,length(xs2));

lin_int_xs1=interp1(t1,xs1,t,'linear');
cub_int_xs1=interp1(t1,xs1,t,'cubic');

lin_int_xs2=interp1(t2,xs2,t,'linear');
cub_int_xs2=interp1(t2,xs2,t,'cubic');

figure;
plot(t,x,t,lin_int_xs1,t,cub_int_xs1);
legend('x','lin int xs1','cub int xs1');
ylabel('Amplitude');
xlabel('Time(s)');
title('xs1');

figure;
plot(t,x,t,lin_int_xs2,t,cub_int_xs2);
legend('x','lin int xs2','cub int xs2');
ylabel('Amplitude');
xlabel('Time(s)');
title('xs2');

%% 1.2 Quantization
%% a) Construction

fs= 5000;
A2=[5,4,3,2,1];
f2=[50,60,70,80,90];
theta2=[0,pi/5,2*pi/5,3*pi/5,4*pi/5];
C2=5;

t_2=linspace(0,0.2,1000);

x2=zeros(1,length(t_2));

for i = 1:C2; 
    x2=x2+A2(i)*sin(2*pi*f2(i)*t+theta2(i));
end

figure;
plot(t_2,x2);
ylabel('Amplitude');
xlabel('Time(s)');
title('x2');

%% b)Quantization

quantizer= @(x,a,b,N) floor(((x-a)/(b-a))*(2^N - 1))*((b-a)/(2^N - 1))+a;

N1=4;
N2=8;

min_val=min(x2);
max_val=max(x2);

xq4=quantizer(x2,min_val,max_val,N1);
xq8=quantizer(x2,min_val,max_val,N2);

%% c) Plotting

figure;
subplot(2,1,1);
plot(t_2,x2,t_2,xq4);
ylabel('Amplitude');
xlabel('Time(s)');
legend('x2','xq4');
title('x2 and xq4');

subplot(2,1,2);
plot(t_2,x2,t_2,xq8);
ylabel('Amplitude');
xlabel('Time(s)');
legend('x2','xq8');
title('x2 and xq8');


%% d) MSE and SQNR

MSE= @(x1,x2) sum((x1-x2).^2)/length(x1);
SQNR= @(x1,x2) MSE(x1,zeros(1,length(x1)))/MSE(x1,x2);
SQNR_to_dB= @(x) 10*log10(x);

SQNR_xq4=SQNR(x2,xq4);
SQNR_xq8=SQNR(x2,xq8);

SQNR_xq4_dB=SQNR_to_dB(SQNR_xq4);
SQNR_xq8_dB=SQNR_to_dB(SQNR_xq8);

disp("SQNR vals:");
disp("SQNR xq4 ->");
disp(SQNR_xq4);
disp("SQNR xq8 ->");
disp(SQNR_xq8);

disp("SQNR vals in dB:");
disp("SQNR xq4 ->");
disp(SQNR_xq4_dB);
disp("SQNR xq8 ->");
disp(SQNR_xq8_dB);


