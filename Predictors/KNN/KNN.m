function PredictY=KNN(K,trainset,testset)
[trainm,trainn]=size(trainset);
[testm,~]=size(testset);
PredictY=zeros(testm,1);
distancev=zeros(trainm,1);
for i=1:testm
    for j=1:trainm
        distancev(j)=0;
        for k=1:trainn-1
            distancev(j)=distancev(j)+(testset(i,k)-trainset(j,k))^2;
        end
        distancev(j)=sqrt(distancev(j));
    end 
    [~,val]=sort(distancev);
    val=val(1:K);
    class1=0;
    class2=0;
    for k=1:size(val,1)   
        if trainset(val(k),end)==1
            class1=class1+1;
        else
            class2=class2+1;
        end
    end
    PredictY(i)=class1/K;
end
end