%% Different secondary path£¬assuming no modeling error(S_est(z)=S(z))
clear;
close all;
taos=[1,5,10];
mu_all=[1e-1,1e-3];
ite_tao_s_est=length(taos);
D_p=10; %the primary path delay
L=10;  %#filter
f_dig=0.1;% the digital frequency
type='white';% the white noise
% type='pink'; %the pink noise
% type='sin';  % the pure tone noise
for ite_1=1:ite_tao_s_est
    D_s=taos(ite_1); % the true secondary path (Here is delay system)
    D_est_s=D_s;% the modeling secondary path (Here Assuming no modeling error)
    figure
    for ite_2=1:2
        mu=mu_all(ite_2);
        [e_ave,t,fs]=Fxlms_v1(f_dig,D_p,L,D_s,D_est_s,mu,type);
        e_ave(e_ave>1e10)=1e10;
        e_ave(e_ave<1e-10)=1e-10;
        semilogy(t/fs,abs(e_ave))
        hold on
        grid on
        xlabel('Time/s','Interpreter','latex','FontSize',12);
        ylabel('MSE','Interpreter','latex','FontSize',12);
    end
    hold off
    legend("$\tau_S="+int2str(taos(ite_1))+",\mu=$"+"1e-"+int2str(-log10(mu_all(1))),...
        "$\tau_S="+int2str(taos(ite_1))+",\mu=$"+"1e-"+int2str(-log10(mu_all(2))),...
        'Interpreter','latex')
    ylim([1e-10,1e10])
end