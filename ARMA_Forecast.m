%% ����Ԥ��ĳ���
%  Ŀ��Ϊ�˻�������ֵ����TimeValFil�еĸ���ֵ
%  Copyright (c) 2019 Mr.���� All rights reserved.
%  ԭ������ https://zhuanlan.zhihu.com/p/69630638
%  �����ַ��https://github.com/KuoHaoJun/ARMA
%% 1.��������
close all
clear all
load Data_EquityIdx   %��˹����ۺ�ָ��
len = 120;
Y = DataTable.NASDAQ(1:len);
plot(Y)
%% 2.ƽ���Լ���
% ԭ����
y_h_adf = adftest(Y)
y_h_kpss = kpsstest(Y)
% ȡlog
Ylog = log(Y)
ylog_h_adf = adftest(Ylog)
ylog_h_kpss = kpsstest(Ylog)
% ȡlog+���
dYlog = diff(Ylog);

dylog_h_adf = adftest(dYlog)
dylog_h_kpss = kpsstest(dYlog)
% ȡ���
dY = diff(Y);
dy_h_adf = adftest(dY)
dy_h_kpss = kpsstest(dY)

aimY = dYlog;  %ѡ����log+�����Ϊ����Ŀ������
%% 3.ȷ��ARMAģ�ͽ���
% ACF��PACF����ȷ������
figure
autocorr(aimY)
figure
parcorr(aimY)
% ͨ��AIC��BIC��׼����ѡ������
max_ar = 3;
max_ma = 3;
[AR_Order,MA_Order] = ARMA_Order_Select(aimY,max_ar,max_ma)   %dY��ҪΪ������
%% 4.�в����
Mdl = arima(AR_Order, 0, MA_Order);
EstMdl = estimate(Mdl,aimY);
[res,~,logL] = infer(EstMdl,aimY);   %res���в�

stdr = res/sqrt(EstMdl.Variance);
figure('Name','�в����')
subplot(2,3,1)
plot(stdr)
title('Standardized Residuals')
subplot(2,3,2)
histogram(stdr,10)
title('Standardized Residuals')
subplot(2,3,3)
autocorr(stdr)
subplot(2,3,4)
parcorr(stdr)
subplot(2,3,5)
qqplot(stdr)
% Durbin-Watson ͳ���Ǽ�������ѧ��������õ�����ض���
diffRes0 = diff(res);  
SSE0 = res'*res;
DW0 = (diffRes0'*diffRes0)/SSE0 % Durbin-Watson statistic����ֵ�ӽ�2���������Ϊ���в�����һ������ԡ�
%% 5.Ԥ��
% ����Ԥ��
for i = 5:length(aimY)
    Predict_dlogY(i+1) = forecast(EstMdl,1,aimY(1:i));  %matlab2018�����°汾дΪPredict_dlogY(i+1) = forecast(EstMdl,1,'Y0',aimY(1:i));
end
figure
plot(aimY);
hold on
Predict_dlogY(1:5)=0;
plot(1:length(aimY),Predict_dlogY(1:length(aimY)))
% ��ԭ
for i = 1:(length(aimY)+1)
    Predict_ylog(i) = log(Y(1))+ sum(aimY(1:(i-1)))+Predict_dlogY(i);  %��ֻ�ԭ
end
Predict_y = exp(Predict_ylog); %������ԭ
figure
plot(Y)
hold on
plot(Predict_y)
% ����׼ȷ��
figure
plot((Predict_y'-Y)/Y)

% �ಽԤ��
[Predict_mul_dlogY,YMSE] = forecast(EstMdl,10,aimY');   %ʹ�õ�ǰ�������ݣ�Ԥ��δ��10������������  %matlab2018�����°汾дΪ[Predict_mul_dlogY,YMSE] = forecast(EstMdl,10,'Y0',aimY'); 
% ��ԭ
for i = 1:10
    Predict_mul_ylog(i) = log(Y(1))+ sum(aimY)+sum(Predict_mul_dlogY(1:i));  %��ֻ�ԭ
end
Predict_mul_y = exp(Predict_mul_ylog);
figure
plot(DataTable.NASDAQ(1:len+10));  %��ԭʼ���ݵĵ�֮��10���㻭����ע����10��������ѵ��ģ��ʱû���õ�����Ϊ��ʵ��ʷ���ݣ����ԶԱȶಽԤ���׼ȷ��
hold on
plot(len:len+10,[Y(length(Y)),Predict_mul_y])