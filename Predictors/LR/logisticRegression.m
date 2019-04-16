% function theta=logisticRegression(x,y)

% % x = [1,2,3;2,3,4;9,8,1;4,5,6;5,6,7;2,6,10;1,5,10];
% % y = [0, 0, 1, 0 ,0 , 1, 1]'; 
% [m,n]=size(x);
% theta = glmfit(x, [y ones(m,1)], 'binomial', 'link', 'logit')
% end
function [theta,predictY]=logisticRegression(trainset, testset,maxIndex, alpha, threshold, maxTimes)


%     data = [0 0 0; 0 1 0; 0 1.5 0; 0.5 0.5 0; 0.5 1 0; 1 0.95 0; 0.5 1.4 0; 1.5 0.51 0; 2 0 0;
% 
%         1.9 0 0; 0 3 1; 0 2.1 1; 0.5 1.8 1; 0.8 1.5 1; 1 1.2 1; 1.5 2 1; 3 0 1; 3 1 1; 2 2 1;
% 
%         3 4 1; 1.8 0.5 1];
% 
%     maxIndex = 2;
%     alpha = 0.1;
%     threshold = 0.00001;
%     maxTimes = 1000;

dataSize = size(trainset);
dataLen = dataSize(1);
param = maxIndex + 1;
theta = zeros(param, 1);
times = 0;
cost0 = 0;
cost1 = 1;
while abs(cost1-cost0) > threshold && times < maxTimes
    times = times + 1;  
    theta0 = theta;
    cost0 = LogisticRegressionCostFun(theta, trainset);
    for i = 1 : dataLen
        tmp = ((1 / (1 + exp(-theta0' * [1, trainset(i,1:maxIndex)]'))) - trainset(i, param)) / dataLen;
        theta(1) = theta(1) - alpha * tmp;
        for j = 2 : param
            theta(j) = theta(j) - alpha * tmp * trainset(i, j - 1); 
        end  
    end
    cost1 = LogisticRegressionCostFun(theta, trainset);
end
[m,n]=size(testset);
predictY=zeros(m,1);
for k=1:m
    x=testset(k,1:maxIndex);
    predictY(k)=1/(1+exp(-theta'*[1,x]'));
end
end
