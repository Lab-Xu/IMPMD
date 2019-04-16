function Change_format(X,file)
%X is the priminal data; file is the output filename(Note it must be a char!)  
%The first colum is the label of the samples, so the dim of the sample is
%n-1 dimensions

[m,n]=size(X);
filename=file;
fid=fopen(filename,'w');
for i=1:m
    fprintf(fid,'%5d ',X(i,1));
    for j=2:n
        fprintf(fid,'%5d: %12.4f ',j-1,X(i,j));
    end
    fprintf(fid,'\n');    
end

fclose(fid);
clear fid i j; 