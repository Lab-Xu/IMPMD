function  AUCbb=AUCwang(tpr,fpr)

for i=1:length(tpr)-1
r(i)=(fpr(i+1)-fpr(i))*tpr(i);
s(i)=0.5*(fpr(i+1)-fpr(i))*(tpr(i+1)-tpr(i));
end
AUCbb=sum(r)+sum(s);
