%% Barbaros ÝNAK
%% 5.1
%% a.
clc;
clear all;
close all;

Fs=45000;
fc=3000;
Tb=0.002;
BitSampleSize=Fs*Tb;

t=linspace(0,Tb,BitSampleSize);

b=randi([0,1],10,1);

b2=repmat(b,1,BitSampleSize)';
b2=b2(:)';

%% b.

s1=sin(2*pi*fc*t);

s0=zeros(1,length(t));

m=[];

for i=1:10
    if b(i)==1
        m=[m s1];
    else
        m=[m s0];
    end

end

y=[];

for i=1:10
   x=m(1+BitSampleSize*(i-1):BitSampleSize*i);
   
   l=sum(x.*s1)-sum(x.*s0);
   
   if l>0
       y=[y repmat([1],1,90)];
   else
       y=[y repmat([0],1,90)];
   end
end

t_total=linspace(0,Tb*10,BitSampleSize*10);
t_bits=linspace(0,10*Tb,10);

figure;

subplot(3,1,1);
plot(t_total,b2);
xlabel('Time(s)');
ylabel('Amp.');
title('Original Bit Stream');

subplot(3,1,2);
plot(t_total,m);
xlabel('Time(s)');
ylabel('Amp.');
title('Modulated Signal');

subplot(3,1,3);
plot(t_total,y);
xlabel('Time(s)');
ylabel('Amp.');
title('Demodulated Bit Stream');

suptitle('BASK');

%% c.

f1=3000;
f2=1500;

s1_bfsk=sin(2*pi*f1*t);
s0_bfsk=sin(2*pi*f2*t);

m_bfsk=[];

for i=1:10
    if b(i)==1
        m_bfsk=[m_bfsk s1_bfsk];
    else
        m_bfsk=[m_bfsk s0_bfsk];
    end

end

y_bfsk=[];

for i=1:10
   x_bfsk=m(1+BitSampleSize*(i-1):BitSampleSize*i);
   
   l_bfsk=sum(x_bfsk.*s1_bfsk)-sum(x_bfsk.*s0_bfsk);
   
   if l_bfsk>0
       y_bfsk=[y_bfsk repmat([1],1,90)];
   else
       y_bfsk=[y_bfsk repmat([0],1,90)];
   end
end

figure;

subplot(3,1,1);
plot(t_total,b2);
xlabel('Time(s)');
ylabel('Amp.');
title('Original Bit Stream');

subplot(3,1,2);
plot(t_total,m_bfsk);
xlabel('Time(s)');
ylabel('Amp.');
title('Modulated Signal');

subplot(3,1,3);
plot(t_total,y_bfsk);
xlabel('Time(s)');
ylabel('Amp.');
title('Demodulated Bit Stream');

suptitle('BFSK');

%% d.

s1_bpsk=sin(2*pi*fc*t);
s0_bpsk=sin(2*pi*fc*t+pi);

m_bpsk=[];

for i=1:10
    if b(i)==1
        m_bpsk=[m_bpsk s1_bpsk];
    else
        m_bpsk=[m_bpsk s0_bpsk];
    end

end

y_bpsk=[];

for i=1:10
   x_bpsk=m(1+BitSampleSize*(i-1):BitSampleSize*i);
   
   l_bpsk=sum(x_bpsk.*s1_bpsk)-sum(x_bpsk.*s0_bpsk);
   
   if l_bpsk>0
       y_bpsk=[y_bpsk repmat([1],1,90)];
   else
       y_bpsk=[y_bpsk repmat([0],1,90)];
   end
end

figure;

subplot(3,1,1);
plot(t_total,b2);
xlabel('Time(s)');
ylabel('Amp.');
title('Original Bit Stream');

subplot(3,1,2);
plot(t_total,m_bpsk);
xlabel('Time(s)');
ylabel('Amp.');
title('Modulated Signal');

subplot(3,1,3);
plot(t_total,y_bpsk);
xlabel('Time(s)');
ylabel('Amp.');
title('Demodulated Bit Stream');

suptitle('BPSK');