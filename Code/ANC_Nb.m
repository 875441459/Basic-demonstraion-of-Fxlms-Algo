%% narrowband noise cancellation
clear;close all;clc
dotnumber=3e3;
fs=8e3;%%sampling rate
f_u=400;%%reference signal's frequency
f_d=410;%%desired signal's frequency
w_u=2*pi*f_u/fs;%%reference signal's digital omega
w_d=2*pi*f_d/fs;%%reference signal's digital omega
u=exp(1j*w_u*(0:dotnumber));
% u1=cos(w_u*(0:dotnumber));
% d=cos(w_d*(0:dotnumber));
d=sin(w_d*(0:dotnumber));
e=zeros(dotnumber,1);
W=zeros(dotnumber,1);
miu=1e-2;
len_S=3;%%delay time =len_S-1
S=zeros(len_S,1);
S(len_S)=1;
num_fft=1000;
delta_w=2*pi/num_fft;
idx_w0=floor(w_u/delta_w+1);
SW=freqz(S,1,num_fft);
freqz(S,1,num_fft)
S_w0=SW(idx_w0);
y=zeros(len_S,1);
for n=1:dotnumber   
    y1=real(W(n)*u(n));
%     y1=(W(n)*u(n));
%     y1=W(n)*u1(n);
    y=[y1;y(1:end-1)];
    e(n)=d(n)+S'*y;
    W(n+1)=W(n)-miu*e(n)*conj(S_w0)*exp(-1j*n*2*pi*f_u/fs);
end
figure
subplot 211
plot(abs(e).^2)
Grid_set
ylabel('MSE','Interpreter','latex','FontSize',12);
axis tight
subplot 212
plot(abs(W))
Grid_set
xlabel('iteration','Interpreter','latex','FontSize',12);
ylabel('$\|W\|$','Interpreter','latex','FontSize',12);
axis tight