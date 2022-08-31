%% Delta Modulation
%% a)
    
clc;
clear all;
close all;

Am=2;
fm=4;
fs=80;

t=linspace(0,1,80);

m=Am*cos(2*pi*fm*t);



%% b)

m_pri=-Am*2*pi*fm*sin(2*pi*fm*t);

delta_min=max(abs(m_pri))/fs;

%% c)

mq=zeros(1,length(m)+1);
DM=zeros(1,length(m));

e=0;
eq=0;

for i=1:length(m)
   
   e = m(i)-mq(i);
   eq= delta_min* sign(e);
   mq(i+1)=mq(i)+eq;
   
   DM(i)=1*sign(e);
    
end

%% d)

mq=mq(2:end);

%% d plotting

figure;
plot(t,m);
hold on;
stairs(t,mq);
xlabel('Time(s)');
ylabel('Amplitude');
legend('m','mq');
title('delta min');

%% e)

P_min=(delta_min^2)*fm/(3*fs);

%% f)

MSE= @(x) sum(x.^2)/length(x);

mse_min=MSE(m-mq);

%% g)

delta=[0.2,0.4,1.4];

mq1=zeros(1,length(mq));
mq2=zeros(1,length(mq));
mq3=zeros(1,length(mq));

DM1=zeros(1,length(m));
DM2=zeros(1,length(m));
DM3=zeros(1,length(m));

% c part
for i=1:length(m)
   
   e = m(i)-mq1(i);
   eq= delta(1)* sign(e);
   mq1(i+1)=mq1(i)+eq;
   DM1(i)=1*sign(e);
    
end

for i=1:length(m)
   
   e = m(i)-mq2(i);
   eq= delta(2)* sign(e);
   mq2(i+1)=mq2(i)+eq;
   DM2(i)=1*sign(e);
    
end

for i=1:length(m)
   
   e = m(i)-mq3(i);
   eq= delta(3)* sign(e);
   mq3(i+1)=mq3(i)+eq;
   DM3(i)=1*sign(e);
    
end

mq1=mq1(2:end);
mq2=mq2(2:end);
mq3=mq3(2:end);


% d part
figure;
plot(t,m);
hold on;
stairs(t,mq1);
xlabel('Time(s)');
ylabel('Amplitude');
legend('m','mq1');
title('Delta_1');

figure;
plot(t,m);
hold on;
stairs(t,mq2);
xlabel('Time(s)');
ylabel('Amplitude');
legend('m','mq2');
title('Delta_2');

figure;
plot(t,m);
hold on;
stairs(t,mq3);
xlabel('Time(s)');
ylabel('Amplitude');
legend('m','mq3');
title('Delta_3');

% e part
P=zeros(1,length(delta));

for i=1:length(delta)
    P(i)=(delta(i)^2)*fm/(3*fs);
end

% f part
mse1=MSE(m-mq1);
mse2=MSE(m-mq2);
mse3=MSE(m-mq3);


%% h)
plot_mse=[mse1,mse2,mse_min,mse3];

plot_P=[P(1),P(2),P_min,P(3)];

sample=1:length(P)+1;

figure;
subplot(2,1,1);
plot(sample,plot_mse);
title('MSE Values');
xlabel('Delta');
ylabel('MSE');

subplot(2,1,2);
plot(sample,plot_P);
title('P Values');
xlabel('Delta');
ylabel('P');

