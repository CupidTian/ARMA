function [AR_Order,MA_Order] = ARMA_Order_Select(data,max_ar,max_ma)
% Copyright (c) 2019 Mr.���� All rights reserved.
% ԭ������ https://zhuanlan.zhihu.com/p/69630638
% �����ַ��https://github.com/KuoHaoJun/ARMA
% ͨ��AIC��BIC��׼����ѡ������
% ���룺
% data��������
% max_arΪARģ����Ѱ��������
% max_maΪMAģ����Ѱ��������
% �����
% AR_OrderrΪARģ���������
% MA_OrderrΪARģ���������

T = length(data);

for ar = 0:max_ar
    for ma = 0:max_ma
        if ar==0&&ma==0
            infoC_Sum = NaN;
            continue
        end
        Mdl = arima(ar, 0, ma);
        [~, ~, LogL] = estimate(Mdl, data, 'Display', 'off');
        [aic,bic] = aicbic(LogL,(ar+ma),T);
        infoC_Sum(ar+1,ma+1) = bic+aic;  %��BIC��AIC֮��Ϊ��׼����ѡȡ Select the sum of BIC and AIC as the standard
    end
end
[x, y]=find(infoC_Sum==min(min(infoC_Sum)));
AR_Order = x -1;
MA_Order = y -1;
end