function feature=Feature_extraction(Positive,Negative)%samples with labels
[m1,n1]=size(Positive);
[m2,n2]=size(Negative);
csp=zeros(n1,1);
csn=zeros(n2,1);
sps=zeros(n1,1);
for i=1:n1
    csp(i)=sum(Positive(:,i));
    csn(i)=sum(Negative(:,i));
    sps(i)=(csp(i)+csn(i))*log(m1/csp(i)+m2/csn(i));
end
[spssort, index] = sort(sps,'descend');
[m,n]=size(index);
micfeature=[];
disfeature=[];
for j=1:m
    if  1<=index(j)&&index(j)<=2204
        micfeature=[micfeature;index(j)];
    else
        disfeature=[disfeature;index(j)];
    end
end
feature=[micfeature(1:100);disfeature(1:100)];
end