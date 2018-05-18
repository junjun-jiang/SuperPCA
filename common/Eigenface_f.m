function [disc_set] =Eigenface_f(Train_SET,Eigen_NUM)
%------------------------------------------------------------------------
% Eigenface computing function
% mTrain_SET = mean(Train_SET,2);
% Dis = dist2(mTrain_SET',Train_SET');
% [val ind]=sort(Dis);
% Train_SET = Train_SET(:,ind(1:round(0.95*size(Train_SET,2))));

[NN,Train_NUM]=size(Train_SET);

% if NN<=Train_NUM % not small sample size case
    
   Mean_Image=mean(Train_SET,2);  
   Train_SET=Train_SET-Mean_Image*ones(1,Train_NUM);
   R=Train_SET*Train_SET'/(Train_NUM-1);
   
%    subplot(2,1,1);plot(Train_SET(:,1:10:end));   xlim([1 103])
%    subplot(2,1,2);imagesc(corr(Train_SET'));
%    subplot(2,1,2);
%    imagesc(R);xlabel('Band Index');ylabel('Band Index');
   
   [V,S]=Find_K_Max_Eigen(R,Eigen_NUM);
%    ratio = S(1)/S(2);
%    plot(S)
%    subplot(1,2,1);semilogy(S);subplot(1,2,2);plot(Train_SET);
   disc_value=S;
   disc_set=V;

% else % for small sample size case
%      
%   Train_SET=Train_SET-(mean(Train_SET,2))*ones(1,Train_NUM);
%   R=Train_SET'*Train_SET/(Train_NUM-1);
%   [V,S]=Find_K_Max_Eigen(R,Eigen_NUM);
%   clear R
%   disc_set=zeros(NN,Eigen_NUM);
%   Train_SET=Train_SET/sqrt(Train_NUM-1);
%   
%   for k=1:Eigen_NUM
%     a = Train_SET*V(:,k);
%     b = (1/sqrt(S(k)));
%     disc_set(:,k)=b*a;
%   end

% end

function [Eigen_Vector,Eigen_Value]=Find_K_Max_Eigen(Matrix,Eigen_NUM)

[NN,NN]=size(Matrix);
[V,S]=eig(Matrix);        %Note this is equivalent to; [V,S]=eig(St,SL); also equivalent to [V,S]=eig(Sn,St); %

S=diag(S);
[S,index]=sort(S);

Eigen_Vector=zeros(NN,Eigen_NUM);
Eigen_Value=zeros(1,Eigen_NUM);

p=NN;
for t=1:Eigen_NUM
    Eigen_Vector(:,t)=V(:,index(p));
    Eigen_Value(t)=S(p);
    p=p-1;
end



