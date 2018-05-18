function Results = seg_im_class(Y,Ln)
[M,N,B]=size(Y);
Y_reshape=reshape(Y,M*N,B);
Gt=reshape(Ln,[1,M*N]);
Class=unique(Gt);
Num=size(Class,2);
Y=cell(1,Num);
index=cell(1,Num);
for i=1:Num
    Results.index{1,i}=find(Gt==Class(i));
    Results.Y{1,i} =Y_reshape(find(Gt==Class(i)),:);
end
