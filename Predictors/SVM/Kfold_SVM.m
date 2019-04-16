function [acc,mcc,sen,spe,auc,pre,prdY,fpr,tpr,predictedY]=Kfold_SVM(rank,Xpos,Xneg,gcs,pth,cv)

% p1=randperm(m1)';
% Xpos=Xpos(p1,:);
% p2=randperm(m2)';
% Xneg=Xneg(p2,:);
[m1,n1]=size(Xpos);[m2,n2]=size(Xneg);
X=[Xpos;Xneg];    
Y=[ones(m1,1);-ones(m2,1)]; 
[m3,n3]=size(X);
% p=randperm(m3)';
 X=X(rank,:);
 Y=Y(rank);
%  [acc,mcc,sen,spe,auc,pre,prdY,fpr,tpr,predictedY]=Kfold_SVM2(Positive_200,Negative_200(1:16987,:),0.005,0.5,10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% K-fold½»²æÑéÖ¤%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 prdY=[]; predictedY=[]; prelabelp=[];  targets=[];
 prelabel=[];
 predictedY=[];
 
 kfold=cv;
 t=fix(m3/kfold);
 for k=1:kfold
   if k==kfold
        Xtrain=X(1:t*(k-1),:);
        Xtest=X(t*(k-1)+1:m3,:);
        Ytrain=Y(1:t*(k-1),:);
        Ytest=Y(t*(k-1)+1:m3,:);
        
   else  
       Xtrain=[X(1:t*(k-1),:);X(t*k+1:m3,:)];
       Xtest=X(t*(k-1)+1:t*k,:);
       Ytrain=[Y(1:t*(k-1));Y(t*k+1:m3)];
       Ytest=Y(t*(k-1)+1:t*k,:);  
   end         
  

    
   Dtrain=[Ytrain Xtrain];Change_format(Dtrain,'Dtrain.txt');
   Dtest=[Ytest Xtest];Change_format(Dtest,'Dtest.txt');
   %0.0325
   
   !E:\libsvm\svmtrain -s 0  -b 1  -t 2  -c  100   -g  gcs     Dtrain.txt

%    !E:\libsvm\svmtrain -s 0  -b 1  -t 1  -d  gcs  Dtrain.txt
%     !E:\libsvm\svmtrain -s 0  -b 1  -t 0  Dtrain.txt
      
   !E:\libsvm\svmpredict -b 1 Dtest.txt Dtrain.txt.model Xesubresult.out
   
   [names,types,x,y,answer] = textread('Xesubresult.out','%s%s%f%d%s');
   
   if str2num(types{1})==-1
       for i=2:length(x)
          prelabelp(i-1)=x(i);
       end
       prdY=[prdY;prelabelp']; 
   else
        for i=2:length(types)
           prelabelp(i-1)=str2num(types{i});
        end
       prdY=[prdY;prelabelp']; 
   end
  k; 
   
   targets=[targets;Ytest];
   
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

