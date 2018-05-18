
function AP_fea = EMP(data, num_PC)
%% /////////////////// Generate PCs //////////////////
[row,col,dim] = size(data);
data = reshape(data, row*col, dim);

num_PC = 5;
P = Eigenface_f(data',num_PC);
PC = data*P;
PC = reshape(PC,[row,col,num_PC]); % principal compoments



%% /////////////////// EMAP //////////////////

area = [50:50:500, 1000, 5000];
std_dev = 2.5:2.5:20;

AP_area = [];
AP_std = [];

for i = 1:num_PC
    img = PC(:,:,i);
    img = (img - min(img(:))) ./ (max(img(:)) - min(img(:)));
    img = int16(1000.*img);
    area_ap = attribute_profile(img,'a',area);
    std_ap = attribute_profile(img,'s',std_dev);
    AP_area = cat(3, AP_area, area_ap);
    AP_std = cat(3, AP_std, std_ap);
end

AP_area = double(reshape(AP_area, row*col, size(AP_area,3)));
AP_std = double(reshape(AP_std, row*col, size(AP_std,3)));
AP_fea = [AP_area./max(AP_area(:)), AP_std./max(AP_std(:))];
%AP_fea = [NormalizeFea(AP_area,1), NormalizeFea(AP_std,1)];

AP_fea = reshape(AP_fea, row, col, size(AP_fea,2));

%area_ap = reshape(area_ap, row*col, size(area_ap,3));
%std_ap = reshape(std_ap, row*col, size(std_ap,3));
%AP_fea = [area_ap./max(area_ap(:)), std_ap./max(std_ap(:))];
%AP_fea = [NormalizeFea(area_ap,1), NormalizeFea(std_ap,1)];




%% ////////////////////////////////////////////////////

%data = NormalizeFea(data,1);
% data = AP_fea;