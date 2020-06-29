%%
I=1;%# reference microphone
J=2;%# secondary source(loudspeaker/actuator)
K=2;%# error microphone
L=10;%the length of filter
len_p=10;% the length of digital Impluse response of primary path
len_s=10;% the length of digital Impluse response of secondary path
M=len_s;
p=randn(len_p,K);% the primary path matrix
S=randn(len_s,K,J);% the Secondary path matrix
% p=eye(len_p,K);
% S=eye(len_s,K,J);
S_est=S;
dotnumber=5e3;
n=1:dotnumber;
f_sig=0.2;
x=sin(2*pi*f_sig*n);
d=zeros(length(n),K);
for k=1:K
    d(:,k)=filter(p(:,k),1,x);
end
W=randn(L,J);%%Do not set to zero matrix,or it can not be renewed.
e=zeros(K,1);
d=zeros(K,1);
d_est=zeros(K,1);

miu=1e-4;
x1=zeros(L,1);
x2=zeros(len_s,1);
y=zeros(M,J);
R=zeros(L,K,J);
e_n=zeros(length(n),1);
d_est=zeros(K,1);
for i=1:length(n)
    x1=[x(i);x1(1:end-1)];%The signal to be filterd by W
    y1=W'*x1;%%If W is set to zero,then y1 will always be zeros always
    y=[y1.';y(1:end-1,:)];
    x2=[x(i);x2(1:end-1)];
    d=zeros(K,1);
    
    for j=1:J
       r1=S_est(:,:,j)'*x2;
       R(:,:,j)=[r1.';R(1:end-1,:,j)];
       d=d+S(:,:,j)'*y(:,j);%%n时刻的期望信号
    end
    R11=permute(R,[1,3,2]);
    for k=1:K
        d_est(k)=sum(sum(W.*R11(:,:,k))); %%trace
    end
    e=d+d_est;
    for j=1:J
    W(:,j)=W(:,j)-miu*R(:,:,j)*e;
    end
    e_n(i)=norm(e)^2;
end
plot(e_n)