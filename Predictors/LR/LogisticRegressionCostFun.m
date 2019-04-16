function cost=LogisticRegressionCostFun(theta, data)



paramLen = length(theta);
X = zeros(paramLen, 1);
dataSize = size(data);
dataLen = dataSize(1);
cost = 0;
for i = 1 : dataLen 
    X(1) = 1; 
    for k = 1 : paramLen - 1   
        X(k + 1) = data(i, k);   
    end
    cost = cost +(-data(i, dataSize(2)) * log(1/(1 + exp(-(theta' * X))))  - (1 - data(i, dataSize(2))) * log(1 - 1/(1 + exp(-(theta' * X)))));
end
cost = cost / dataLen;
end
