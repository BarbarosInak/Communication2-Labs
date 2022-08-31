%% Barbaros İNAK LAB 3
%% 3.1) Transmitter
%a)

clear all;
clc;
close all;

N=[1 0 0 1 1 0 0 1 0 1];

%b)
Fs=1000;
Tb=0.1;
t=linspace(0,1,Fs);

%c)
t_symbol=linspace(0,0.1,100);

s0=-1*ones(1,length(t_symbol));
s1=ones(1,length(t_symbol));

%d)

s=[s1 s0 s0 s1 s1 s0 s0 s1 s0 s1];

%% 3.2) Channel

SNR=-15:1:15;

r=zeros(length(SNR),length(s));


for i=1:length(SNR)
   
    r(i,:)=awgn(s,SNR(i),'measured');
    
end

%% 3.3) Receiver

Ts=1;
Tb=100;

Wb=Tb/Ts;

r0=zeros(1,length(N));
r1=zeros(1,length(N));


for k = 1:length(N)
    sum_1=0;
    sum_0=0;
    for n= (k-1)*Wb+1:k*Wb
        sum_1 = sum_1+r(31,n*Ts)*s1((n-(k-1)*Wb)*Ts);
        sum_0 = sum_0+r(31,n*Ts)*s0((n-(k-1)*Wb)*Ts);
    end
    r0(k)=sum_0;
    r1(k)=sum_1;
    
end

%% 3.4) Probability Error

SNR_x=-15:1:15;

db_to_lin= @(x) 10.^(x/10);

MSE= @(c,t) sum((c-t).^2)/length(c);

SNR= @(c,t) MSE(c,zeros(1,length(c)))/MSE(c,t);

%% 3.4) a)


it_SNR=zeros(1,length(SNR_x));



for k=1:length(SNR_x)
    sum2=0;
    for j=1:100
        sum2 = sum2+ SNR(s,r(k,:));
    end
    it_SNR(k)=sum2/100;
end

%% 3.4) b)
%b)

SNR_x_lin=db_to_lin(SNR_x);

Pe=qfunc(sqrt(2*SNR_x_lin)); %sqrt should be added here.


%% 3.5) Plotting

%a)
r0_0=zeros(1,length(N));
r1_0=zeros(1,length(N));


for k = 1:length(N)
    sum_1=0;
    sum_0=0;
    for n= (k-1)*Wb+1:k*Wb
        sum_1 = sum_1+r(16,n*Ts)*s1((n-(k-1)*Wb)*Ts);
        sum_0 = sum_0+r(16,n*Ts)*s0((n-(k-1)*Wb)*Ts);
    end
    r0_0(k)=sum_0;
    r1_0(k)=sum_1;
    
end

r0_m15=zeros(1,length(N));
r1_m15=zeros(1,length(N));


for k = 1:length(N)
    sum_1=0;
    sum_0=0;
    for n= (k-1)*Wb+1:k*Wb
        sum_1 = sum_1+r(1,n*Ts)*s1((n-(k-1)*Wb)*Ts);
        sum_0 = sum_0+r(1,n*Ts)*s0((n-(k-1)*Wb)*Ts);
    end
    r0_m15(k)=sum_0;
    r1_m15(k)=sum_1;
    
end

%b)

figure;
subplot(2,1,1);
plot(t,s);
xlabel('Time(s)');
ylabel('Amp.');
title('s(t)');

subplot(2,1,2);
plot(t,r(31,:));
xlabel('Time(s)');
ylabel('Amp.');
title('r(t) with 15 dB AWGN');

figure;
subplot(2,1,1);
plot(t,s);
xlabel('Time(s)');
ylabel('Amp.');
title('s(t)');

subplot(2,1,2);
plot(t,r(16,:));
xlabel('Time(s)');
ylabel('Amp.');
title('r(t) with 0 dB AWGN');


figure;
subplot(2,1,1);
plot(t,s);
xlabel('Time(s)');
ylabel('Amp.');
title('s(t)');

subplot(2,1,2);
plot(t,r(1,:));
xlabel('Time(s)');
ylabel('Amp.');
title('r(t) with -15 dB AWGN');


%c 

num_of_scatter=1:10;

figure;
scatter(num_of_scatter,r0,'fill');
hold on
scatter(num_of_scatter,r1,'fill');
xlabel('Time(s)');
ylabel('Amp.');
title('r0 and r1 with 15 dB AWGN');
legend('r0','r1');

figure;
scatter(num_of_scatter,r0_0,'fill');
hold on
scatter(num_of_scatter,r1_0,'fill');
xlabel('Time(s)');
ylabel('Amp.');
title('r0 and r1 with 0 dB AWGN');
legend('r0','r1');

figure;
scatter(num_of_scatter,r0_m15,'fill');
hold on
scatter(num_of_scatter,r1_m15,'fill');
xlabel('Time(s)');
ylabel('Amp.');
title('r0 and r1 with -15 dB AWGN');
legend('r0','r1');

%d

figure;
semilogy(SNR_x,Pe);
xlabel('SNR dB');
ylabel('Pe');
title('Pe vs SNR with qfunc (corrected)');

%%

SNR_arr=-15:1:15;

error=zeros(length(SNR_arr),1000000);

for i=1:length(SNR_arr)
    
    
    
    for j=1:1000000
        rec=awgn(s,SNR_arr(i),'measured');
        
        Ts=1;
        Tb=100;

        Wb=Tb/Ts;

        r0=zeros(1,length(N));
        r1=zeros(1,length(N));


        for k = 1:length(N)
            sum_1=0;
            sum_0=0;
            for n= (k-1)*Wb+1:k*Wb
                sum_1 = sum_1+rec(n*Ts)*s1((n-(k-1)*Wb)*Ts);
                sum_0 = sum_0+rec(n*Ts)*s0((n-(k-1)*Wb)*Ts);
            end
            r0(k)=sum_0;
            r1(k)=sum_1;

        end
        er=0;
        for h=1:10
            if r0(h)>r1(h)
                if N(h)== 1
                    er=er+1;
                end
            else
                if N(h)== 0
                    er=er+1;
                end
            end
        end
        error(i,j)=er;
    end
    
end

disp('done');

