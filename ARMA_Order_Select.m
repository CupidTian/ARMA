function [AR_Order,MA_Order] = ARMA_Order_Select(data,max_ar,max_ma)
% ͨ��AIC��BIC��׼����ѡ������
% ���룺
% data��������
% max_arΪARģ����Ѱ��������
% max_maΪMAģ����Ѱ��������
% �����
% AR_OrderrΪARģ���������
% MA_OrderrΪARģ���������
T = length(data);
Options = optimoptions(@fmincon,'MaxIter',2000, 'MaxFunEvals', 2000, ...
    'Display', 'notify', 'TolCon', 1e-12, 'TolFun', 1e-12, ...
    'TolX', 1e-12);
for ar = 0:max_ar
    for ma = 0:max_ma
        Mdl = arima(ar, 0, ma);
        [~, ~, LogL] = estimate(Mdl, data, 'Options', Options);
        % Compute the different information criterion for the 3 models
        infoC = info_val(LogL, (ar+ma), T);
        infoC_Sum(ar+1,ma+1) = sum(infoC);  %����ֱ�ӽ�����������ͣ�Ҳ����ֻ������һ������Ϊ��׼
    end
end
[x, y]=find(infoC_Sum==min(min(infoC_Sum)));
AR_Order = x -1;
MA_Order = y -1;
end