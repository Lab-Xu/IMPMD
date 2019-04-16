[m1,n1]=size(Positive_200);
[m2,n2]=size(Negative_200);
Y=[ones(m1,1);zeros(m2,1)]; Y=Y(rank);
feature=[prdY_svm,prdY_knn,prdY_reg];
[m3,n3]=size(feature);
b=regress(Y,feature);
prdY=zeros(m3,1);
for i=1:size(feature,1)
    prdY(i)=b'*feature(i,:)';
end
for i=1:length(prdY)
    if prdY(i)>=0.5    %¿Éµ÷
       predictedY(i,:)=1;
    else
       predictedY(i,:)=-1;
    end
end
%%%%%%%%%%%%%%%%%%roc curve
targets=Y;
targets1=[];
targets1=[targets1;Y];
zz=find(targets1==0);
for i=1:length(zz)
    targets1(zz(i))=-1;
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
