%% ʹ��Fun_ARIMA_Forecast����ʵ��Ԥ��
% ����Ԥ��
%  Copyright (c) 2019 Mr.���� All rights reserved.
%  ԭ������ https://zhuanlan.zhihu.com/p/69630638

close all
clear all
addpath ../funs %��funs�ļ�����ӽ�·��
load Data_EquityIdx   %��˹����ۺ�ָ��
len = 100;
data = DataTable.NASDAQ(1:len); %���Ҫ�滻���ݣ����˴�data�滻���ɡ�
forData1 = zeros(1,len); %ȫ����ʼ��Ϊ0
for i = 30:len
    forData1(i+1) = Fun_ARIMA_Forecast(data(1:i),1,2,2,'off');
end
figure()
plot(31:len,data(31:len))
hold on
plot(31:len,forData1(31:len))
legend('ԭʼ����','����Ԥ������')
