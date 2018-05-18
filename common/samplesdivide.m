function [DataTest, DataTrain, CTest, CTrain, indian_pines_map] = samplesdivide(indian_pines_corrected,indian_pines_gt,train,randpp)

[m, n, p] = size(indian_pines_corrected);
CTrain = [];CTest = [];
DataTest  = [];
DataTrain = [];
indian_pines_map = uint8(zeros(m,n));
data_col = reshape(indian_pines_corrected,m*n,p);

for i = 1:max(indian_pines_gt(:))
    ci = length(find(indian_pines_gt==i));    
    [v]=find(indian_pines_gt==i);    
    datai = data_col(find(indian_pines_gt==i),:);  
    if train>1
        cTrain = round(train);
    elseif train<1
        cTrain = round(ci*train);
    end
    if train>ceil(ci/2)
        cTrain = ceil(ci/2);
    end
    cTest  = ci-cTrain;
    CTrain = [CTrain cTrain];
    CTest = [CTest cTest];
    index = randpp{i};
    DataTest = [DataTest; datai(index(1:cTest),:)];
    DataTrain = [DataTrain; datai(index(cTest+1:cTest+cTrain),:)];    
   
    indian_pines_map(v(index(1:cTest))) = i;    
end

%%%%%%%% Normalize
DataTest = fea_norm(DataTest);
DataTrain = fea_norm(DataTrain);
 