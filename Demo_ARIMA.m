%% ʹ��Fun_ARIMA_Forecast����ʵ��Ԥ��
%  ԭ������ https://zhuanlan.zhihu.com/p/69630638

close all
clear all
addpath ../funs %��funs�ļ�����ӽ�·��
load Data_EquityIdx   %��˹����ۺ�ָ��
data = DataTable.NASDAQ(1:1200); %���Ҫ�滻���ݣ����˴�data�滻���ɡ�
[forData1,lower1,upper1] = Fun_ARIMA_Forecast(data,300,3,3,'on'); %Ԥ��δ��n�����ݣ�p��q����Ϊ3,3���ú����Ĳ�����Ϣ���ں����ļ��ڲ鿴
