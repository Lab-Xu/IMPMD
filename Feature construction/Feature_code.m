function code=Feature_code(SR,SD,seq)
[m,n]=size(seq);
code=[];
for i=1:m
    a=all_negative(i,1);
    b=all_negative(i,2);
    code_miRNA_disease=[SR(a,:),SD(b,:)];
   code=[code;code_miRNA_disease];

end
end