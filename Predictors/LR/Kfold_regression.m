function [acc,mcc,sen,spe,auc,pre,prdY,fpr,tpr,predictedY]=Kfold_regression(Xpos,Xneg,pth,cv, alpha, threshold, maxTimes)

[m1,n1]=size(Xpos);
[m2,n2]=size(Xneg);
X=[Xpos;Xneg];
Y=[ones(m1,1);-ones(m2,1)];
[m3,n3]=size(X);  
%  p=randperm(m3)';
%  X=X(p,:);
%  Y=Y(p);
prdY=[];
targets=[];
predictedY=[];
indices=crossvalind('Kfold',X(1:m3,n3),cv);
for k=1:cv 
    test = (indices == k);
    train = ~test;
    train_data=X(train,:);
    train_target=Y(train,:);
    test_data=X(test,:);
    test_target=Y(test,:);
    %     maxIndex=n1;
    %     [theta,prdY_k]=logisticRegression([train_data,train_target], maxIndex, alpha, threshold, maxTimes);
    %     prdY=[prdY;prdY_k];
    trainset=[train_data,train_target];
    testset=[test_data,test_target];
    dataSize = size(trainset);
    dataLen = dataSize(1);
    paramLen = dataSize(2);
    maxIndex=paramLen-1;
    theta = zeros(paramLen, 1);
    times = 0;
    cost0 = 0;
    cost1 = 1;
    while abs(cost1-cost0) > threshold && times < maxTimes
        times = times + 1;
        theta0 = theta;
        cost0 = LogisticRegressionCostFun(theta, trainset);
        for i = 1 : dataLen
            tmp = ((1 / (1 + exp(-theta0' * [1, trainset(i,1:maxIndex)]'))) - trainset(i, paramLen)) / dataLen;
            theta(1) = theta(1) - alpha * tmp;
            for j = 2 : paramLen
                theta(j) = theta(j) - alpha * tmp * trainset(i, j - 1);
            end
        end
        cost1 = LogisticRegressionCostFun(theta, trainset);
    end
    [m,n]=size(testset);
    predY_k=zeros(m,1);
    for kk=1:m
        x=testset(kk,1:maxIndex);
        predY_k(kk)=1/(1+exp(-theta'*[1,x]'));
    end
    prdY=[prdY;prdY_k];
end
for i=1:length(prdY)
    if prdY(i)>=pth    
        predictedY(i,:)=1;
    else
        predictedY(i,:)=-1;
    end
end
%%%%%%%%%%%%%%%%%%roc curve
targets=[targets;Ytest];
targets1=[];
targets1=[targets1;Ytest];
zz=find(targets==-1);
for i=1:length(zz)
    targets(zz(i))=0;
end
[tpr,fpr,thresholds] = roc(targets',prdY');
AUCbb=AUCwang(tpr,fpr);
hold on, plot(fpr,tpr)


P=size(find(targets1==1),1);
TP=size(find(predictedY==targets1 & predictedY==1),1);
FN=size(find(predictedY~=targets1&targets1==1),1);
N=size(find(targets1==-1),1);
TN=size(find(predictedY==targets1&predictedY==-1),1);
FP=size(find(predictedY~=targets1&targets1==-1),1);

acc=length(find(predictedY==targets1))/length(targets1);
sen=TP/(P);
spe=TN/(N);
mcc=(TP*TN-FP*FN)/sqrt((TP+FN)*(TP+FP)*(TN+FP)*(TN+FN));
auc=AUCbb;
pre=TP/(TP+FP);
end

