function [acc,mcc,sen,spe,auc,pre,prdY,fpr,tpr,predictedY]=Kfold_KNN(rank,Xpos,Xneg,pth,cv,K)
%  [acc,mcc,sen,spe,auc,pre,prdY,fpr,tpr,predictedY]=crossvalidation(randperm(60)',Positive_200(1:30,:),Negative_200(1:30,:),0.5,10,3);
[m1,n1]=size(Xpos);
 [m2,n2]=size(Xneg);
 X=[Xpos;Xneg];    
 Y=[ones(m1,1);-ones(m2,1)]; 
 [m3,n3]=size(X);  
%  p=randperm(m3)';
  X=X(rank,:);
  Y=Y(rank);
 K_neighbor=K; 
 prdY=[]; predictedY=[]; 
 targets=[];
 predictedY=[];
 Ytest=[];
 kfold=cv;
t=fix(m3/kfold);
 for k=1:kfold
   if k==kfold
        train_data=X(1:t*(k-1),:);
        test_data=X(t*(k-1)+1:m3,:);
        train_target=Y(1:t*(k-1),:);
        test_target=Y(t*(k-1)+1:m3,:);
        
   else  
       train_data=[X(1:t*(k-1),:);X(t*k+1:m3,:)];
       test_data=X(t*(k-1)+1:t*k,:);
       train_target=[Y(1:t*(k-1));Y(t*k+1:m3)];
       test_target=Y(t*(k-1)+1:t*k,:);  
   end       
     prdY_k=KNN( K_neighbor,[ train_data,train_target],[test_data,test_target]);
     prdY=[prdY;prdY_k];
%     test_target=[test_target;test_target];
 end

 for i=1:length(prdY)
    if prdY(i)>=pth    
       predictedY(i,:)=1;
    else
       predictedY(i,:)=-1;
    end
end
%%%%%%%%%%%%%%%%%%roc curve
targets=Y;
targets1=[];
targets1=[targets1;Y];
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

