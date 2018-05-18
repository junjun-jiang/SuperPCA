function label=getlabel(classSize)

label = [];
for i=1:length(classSize)
    label = [label i*ones(1,classSize(i))];
end