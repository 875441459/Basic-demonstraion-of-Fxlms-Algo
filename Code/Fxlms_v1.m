function [e_ave,t,fs]=Fxlms_v1(f_dig,D_p,L,D_s,D_est_s,mu,type)
%------------------------------------------------------------------------%
%input
% f_dig:the digital frequency [0,1]
% D_p:the delay of the primary path
% L:length of filter
% D_s:the delay of the true secondary path
% D_est_s:the delay of the modeling secondary path
% mu:the step value
% type:the noise type('sin' for pure tone, 'white' for white noise, 'pink'
% for pink noise)
%------------------------------------------------------------------------%
%output
% e_ave:the averaged MSE
% t:the time index for plot
% fs:the sampling rate(Here setting to 16kHz)
%------------------------------------------------------------------------%
% Written by Jinfu Wang, Institute of Acoustics, University of Chinese
% Academy of Science
% Update Date: 2020/June/28
%------------------------------------------------------------------------%
T=1;
fs=16e3;
f=f_dig*fs;
t=0:fs*T;
dotnumber=length(t);
iterall=5;
e_ave=zeros(dotnumber,1);
for i=1:iterall
    if strcmp(type,'sin')
       x=sin(2*pi*f_dig*t);
    elseif strcmp(type,'white')
%        x=wgn(dotnumber,1,0);
       x=randn(dotnumber,1);
    elseif strcmp(type,'pink')
        x=pinknoise(dotnumber,1);
    end
    %%初级路径(the primary path)
    p=zeros(D_p+1,1);%%延迟L1，则有L1+1个向量
    p(D_p)=1;
    d=filter(p,1,x);
    w=zeros(L,1);
    x1=zeros(L,1);%
    x2=zeros(D_est_s+1,1);%
    y1=zeros(D_s+1,1);%
    e1=zeros(dotnumber,1);
    r1=zeros(L,1);
    %%次级路径
    s=zeros(D_s+1,1);
    s(D_s+1)=1;
    s_est=zeros(D_est_s+1,1);
    s_est(D_est_s+1)=1;
    for n1=1:dotnumber
        x1=[x(n1);x1(1:end-1)];
        y1=[x1'*w;y1(1:end-1)];
        e1(n1)=d(n1)+y1'*s;%In reality, two sources are "added"
        x2=[x(n1);x2(1:end-1)];
        r1=[x2'*s_est;r1(1:end-1)];
        w=w-mu*e1(n1)*r1;
    end
    e_ave=e_ave+e1.^2;
end
e_ave=e_ave/iterall;