
function randp = randpGen(gth,IterNum)
randp = cell(1,IterNum);
for i=1:IterNum
    for c=1:max(gth(:))
        randp{1,i}{1,c} = randperm(length(find(gth==c)));
    end    
end