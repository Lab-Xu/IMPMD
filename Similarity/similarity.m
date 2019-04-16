 clc
 [mdh,ndh]=size(disease_HMDD);
 [mdc,ndc]=size(disease_CTD); 
 DV1=[];
 allGraph=cell(size(disease_HMDD,1),2);
 disease_HMDD_c=[];
 for i=1:mdh
     id=ismember(disease_CTD(:,2),disease_HMDD(i,2));
     local=find(id==1);
     disName=disease_CTD(local,1);  
     disease_HMDD_c=[disease_HMDD_c;disName];
     [len, wid] = size(Numberdis);
     count = 0;
     Set = {};
     for j = 1:len    
         s = isequal(Namedis{j}, char(disName));
         if s == 1
             count = count + 1;
             Set(count,:) = [Namedis(j),Numberdis(j)];
         end
     end
     [len1,~] = size(Set);
     Namegraph={};
     Layergraph={};
     if len1==0 
         Distance=1;
         Namegraph=Namegraph;
         Layergraph=Layergraph;
     else
         
         for k = 1:len1
             lennum=length(Set{k,2});
             number=Set{k,2};
             lenn=(lennum-3)/4;
             for j=1:lenn
                 str=number(1:lennum-j*4);   
                 Index=ismember(Numberdis, str);
                 Indexn=find(Index==1); 
                 name=Namedis(Indexn);
                 [m,n]=find(cellfun(@(x) ismember(name,x),Namegraph));
                 sizem=size(m,1);
                 if isempty(m)==1    
                     Namegraph=[Namegraph;name];
                     Layergraph=[Layergraph;j];
                 else
                     for v=1:sizem
                         if  isequal(j,char(Layergraph{m(v)}))==1 
                             Namegraph=Namegraph;
                             Layergraph=Layergraph;
                         else           
                             Namegraph=[Namegraph;name];
                             Layergraph=[Layergraph;j];
                         end
                     end
                 end
             end
         end
     end
 
         Graph=[Namegraph, Layergraph];
         namegraph=reshape(Namegraph,[1,size(Namegraph,1)]);
         allnamegraph=[disName,namegraph];
         layergraph=reshape(Layergraph,[1,size(Layergraph,1)]);
         alllayergraph=[0,layergraph];
         graph=cell(1,2);
         graph(1)={allnamegraph};
         graph(2)={alllayergraph};
         allGraph(i,:)=graph;
         [p,q]=size(Graph);
         Distance=1;
         for l=1:p
             Distance=Distance+0.5^char(Graph{l,2});
         end        
     DV1=[DV1; Distance];
 end


SS=[];
SSD=[];
Cc=[];
for r=1:size(disease_HMDD,1)
    disName=allGraph{r,1};
    sizedis=size(disName,2);
    ss=0;
    
    for rr=1:sizedis
        countdag=0;
        for g=1:size(allGraph,1)
            allgraphs=allGraph{g,1};
            if isempty(allgraphs)==0
                [mm,nn]=find(cellfun(@(x) ismember(disName(rr),x),allgraphs));
            end
            if isempty(mm)==0
                countdag=countdag+1;
            end
        end
        ss=ss-log(countdag/size(disease_HMDD,1));
    end
   SS=[SS;ss];   
countdagd=0;
for g=1:size(allGraph,1)
    allgraphs=allGraph{g,1};
    if isempty(allgraphs)==0
        [mm,nn]=find(cellfun(@(x) ismember(disease_HMDD_c(r,1),x),allgraphs));
    end
    if isempty(mm)==0
        countdagd=countdagd+1;
    end
end
ssd=-log(countdagd/size(disease_HMDD,1));
SSD=[SSD,ssd];

end


DS=[];
for s=1:size(disease_HMDD,1)
    ds=[];
    graph1=allGraph{s,1};
    layer1=allGraph{s,2};
    size1=size(graph1,2);
    for t=s:size(disease_HMDD,1)
        graph2=allGraph{t,1};
        layer2=allGraph{t,2};
        size2=size(graph2,2);
        dis1=0;
        dis2=0;
        countcom=0;
        Diseaset1=[]; Diseaset2=[];
        ss1=0;
        ss2=0;
        if s==t
            dv=1;
        else
            for q=1:size1 
                [mm1,nn1]=find(cellfun(@(x) ismember(graph1(q),x),graph2));
                size3=size(nn1,2);
                if size3~=0
                    for r=1:size3
                        diseaset2=graph2(nn1(r));
                        Diseaset2=[Diseaset2,diseaset2];
                        diseaset1=graph1(q);
                        Diseaset1=[Diseaset1,diseaset1];
                        Diseaset1=unique(Diseaset1, 'first');
                        Diseaset2=unique(Diseaset2, 'first');                 
                    end
                end
            end
            [md1,nd1]=size(Diseaset1);
            [md2,nd2]=size(Diseaset2);
         
            for dd1=1:nd1
                 [ml1,nl1]=find(cellfun(@(x) ismember(Diseaset1(dd1),x),graph1)); 
                 for r1=1:size(nl1,2)
                  dis1=dis1+0.5^char(layer1{nl1(r1)});
                 end
               
                countdag1=0;
                for g=1:size(allGraph,1)
                    allgraphs=allGraph{g,1};
                    if isempty(allgraphs)==0
                        [mm,nn]=find(cellfun(@(x) ismember(Diseaset1(dd1),x),allgraphs));
                    end
                    if isempty(mm)==0
                        countdag1=countdag1+1;
                    end
                end
                ss1=ss1-log(countdag1/size(disease_HMDD,1));
            end

            for dd2=1:nd2
                [ml2,nl2]=find(cellfun(@(x) ismember(Diseaset2(dd2),x),graph2)); 
                for r2=1:size(nl2,2)
                dis2=dis2+0.5^char(layer2{nl2(r2)});
                end
                countdag2=0;
                for g=1:size(allGraph,1)
                    allgraphs=allGraph{g,1};
                    if isempty(allgraphs)==0
                        [mm,nn]=find(cellfun(@(x) ismember(Diseaset2(dd2),x),allgraphs));
                    end
                    if isempty(mm)==0
                        countdag2=countdag2+1;
                    end
                end
                ss2=ss2-log(countdag2/size(disease_HMDD,1));
            end
            dv1=(dis1+dis2)/(DV1(s)+DV1(t));
            dv2=(ss1+ss2)/(SS(s)+SS(t));
            dv=(dv1+dv2)/2;
        end
        ds=[ds,dv];
        s
        t
    end
    DS=[DS,ds];
end

m=length(DS);
n=(-1+sqrt(1+8*m))/2 ; 
SD_matix=zeros(n,n);

for i=1:n
    for j=i:n
        index=sum(n:-1:n-i+2)+j-i+1;  
        SD_matix(i,j)=DS(index);       
    end
end
 SD_matix= SD_matix+ SD_matix'- eye(size(SD_matix,1));

 
 

Assocdisease=cell(size(disease_HMDD,1),1);
% count=0;
for k=1:size(adjacent_matrix,1)
%  count=count+sum(adjacent_matrix(k,:));
   assocdisease={};
   position=find(adjacent_matrix(k,:)==1);
   assocdisease=disease_HMDD(position);
  Assocdisease(k,1)={assocdisease};
end 

RF=[];
for p=1:size(miRNA,1) 
    indisease1=Assocdisease{p,1};
    FS=[];
    for q=p:size(miRNA,1)
        indisease2=Assocdisease{q,1};
        SS1=[];SS2=[];
        if p==q
            funcsim=1;
        else
         
            for r=1:size(indisease1,2) 
                [idc1,idv1]=find(cellfun(@(x) ismember(indisease1(r),x),disease_HMDD)); 
                ss2=[];
                for s=1:size(indisease2,2) 
                    [idc2,idv2]=find(cellfun(@(x) ismember(indisease2(s),x),disease_HMDD));
                    ss1=SD_matix(idc1,idc2);
                    ss2=[ss2,ss1];
                end
                ss=max(ss2);
                SS1=[SS1,ss];
            end
            for rr=1:size(indisease2,2) 
                [idc11,idv11]=find(cellfun(@(x) ismember(indisease2(rr),x),disease_HMDD)); 
                ss22=[];
                for ss=1:size(indisease1,2) 
                    [idc22,idv22]=find(cellfun(@(x) ismember(indisease1(ss),x),disease_HMDD));
                    ss11=SD_matix(idc11,idc22);
                    ss22=[ss22,ss11];
                end
                ss=max(ss22);
                SS2=[SS2,ss];
            end
            funcsim=(sum(SS1)+sum(SS2))/(size(indisease1,2)+size(indisease2,2));        
        end
        FS=[FS,funcsim];
        p
        q
    end
    RF=[RF;FS];
end


m=length(RF);
n=(-1+sqrt(1+8*m))/2 ; 
FR_matix=zeros(n,n);

for i=1:n
    for j=i:n
        index=sum(n:-1:n-i+2)+j-i+1;  
        FR_matix(i,j)=DS(index);       
    end
end
 FR_matix= FR_matix+ FR_matix'- eye(size(FR_matix,1));

[m,n]=size(association_matrix);
Sumv=0;
for i=1:size(association_matrix,1)
    sumv=0;
    for j=1:size(association_matrix,2)
        sumv=sumv+association_matrix(i,j)^2;
    end
    Sumv=Sumv+sumv;
end
betar=1/(Sumv/m);
betad=1/(Sumv/n);

GR_all=[];
for p=1:size(association_matrix,1)
    row1=association_matrix(p,:);
    GR=[];
    for q=1:size(association_matrix,1)
        row2=association_matrix(q,:);
        row=row1-row2;
        sum=0;
        for i=1:size(row,2)
            sum=sum+row(i)^2;
        end
        gr=exp(-betad*sum);
        GR=[GR,gr];
    end
    GR_all=[GR_all;GR];
end

GD_all=[];
for r=1:size(association_matrix,2)
    column1=association_matrix(:,r);
    GD=[];
    for s=1:size(association_matrix,2)
        column2=association_matrix(:,s);
        column=column1-column2;
        sum=0;
        for i=1:size(column,1)
            sum=sum+column(i)^2;
        end
        gd=exp(-betad*sum);
        GD=[GD,gd];
    end
    GD_all=[GD_all;GD];
end

for i=1:size(FR_matrix,1)
    for j=1:size(FR_matrix,2)
        SR_all=JR_all;
        SR_all(i,j)=FR_matrix(i,j);
    end
end

for i=1:size(SD_matrix,1)
    for j=1:size(SD_matrix,2)
        SD_all=JD_all;
        SD_all(i,j)=SD_matrix(i,j);
    end
end

SUMV=[];
for s=1:m
     sumv=sum(association_matrix(s,:));
     SUMV=[SUMV;sumv];
 end
 SUMC=[];
 for t=1:n
     sumc=sum(association_matrix(:,t));
     SUMC=[SUMC;sumc];
 end
JR_all=[]; 
 for i=1:m
     row1=association_matrix(i,:);
     JR=[];  
     for j=1:m
         row2=association_matrix(j,:);
         count=0;
         for p=1:n
             if row1(p)==row2(p)&&row1(p)==1
                 count=count+1; 
             end
         end
         jm=count/(SUMV(i)+SUMV(j)-count); 
         JR=[JR,jm];
     end
     JR_all=[JR_all;JR];
 end

 JD_all=[]; 
 for i=1:n
     column1=association_matrix(:,i);
     JD=[];  
     for j=1:n
         column2=association_matrix(:,j);
         count=0;
         for p=1:m
             if column1(p)==column2(p)&&column1(p)==1
                 count=count+1; 
             end
         end
         jd=count/(SUMC(i)+SUMC(j)-count); 
         JD=[JD,jd];
     end
     JD_all=[JD_all;JD];
 end
  
 SR=[SR_all,JR_all];
 SD=[SD_all,JD_all];