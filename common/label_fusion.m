function predict_label = label_fusion(predict_labelS);

for i=1:size(predict_labelS,1)
    temp = tabulate(predict_labelS(i,:));
    [val ind] = max(temp(:,2));    
    predict_label(i,1) = temp(ind,1);
end