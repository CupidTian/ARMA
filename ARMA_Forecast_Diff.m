%% ����Ԥ��ĳ���
%  ��ARMA_Forcast.m��ͬ���ó���ȡ������ʹ��n�ײ�ֵķ���ʹ����ƽ��
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
% һ�ײ�֣����ƽ�ȡ�������ɲ�ƽ�ȵĻ����ٴ����֣�ֱ��ͨ������
Yd1 = diff(Y);
yd1_h_adf = adftest(Yd1)
yd1_h_kpss = kpsstest(Yd1)

%% 3.ȷ��ARMAģ�ͽ���
% ACF��PACF����ȷ������
figure
autocorr(Y)
figure
parcorr(Y)
% ͨ��AIC��BIC��׼����ѡ������
max_ar = 3;
max_ma = 3;
[AR_Order,MA_Order] = ARMA_Order_Select_Diff(Y,max_ar,max_ma,1);      %dY��ҪΪ������,��ȡARMA_Order_Select_DiffԴ����鿴source.txt
%% 4.�в����
Mdl = arima(AR_Order, 1, MA_Order);  %�ڶ�������ֵΪ1����һ�ײ��
EstMdl = estimate(Mdl,Y);
[res,~,logL] = infer(EstMdl,Y);   %res���в�

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
for i = 5:length(Y)
    Predict_Y(i+1) = forecast(EstMdl,1,Y(1:i));   %matlab2018�����°汾дΪPredict_Y(i+1) = forecast(EstMdl,1,'Y0',Y(1:i)); 
end
figure
plot(Y)
hold on
plot(6:length(Predict_Y),Predict_Y(6:length(Predict_Y)))