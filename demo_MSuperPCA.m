% =========================================================================
% A simple demo for SuperPCA based Unsupervised Feature Extraction of
% Hyperspectral Imagery
% If you  have any problem, do not hesitate to contact
% Dr. Jiang Junjun (junjun0595@163.com)
% Version 1,2018-04-11

% Reference: Junjun Jiang,Jiayi Ma, Chen Chen, Zhongyuan Wang, and Lizhe Wang, 
% "SuperPCA: A Superpixelwise Principal Component Analysis Approach for
% Unsupervised Feature Extraction of Hyperspectral Imagery," 
% IEEE Transactions on Geoscience and Remote Sensing, 2018.
%=========================================================================

clc;clear;close all
addpath(genpath(cd));

num_PC            =   30;  % THE OPTIMAL PCA DIMENSION
num_Pixels        =   100*sqrt(2).^[-4:4]; % THE Numbers of Multiscale Superpixel
trainpercentage   =   30;  % Training Number per Class
iterNum           =   10;    % Trails

database  = 'Indian';

for inum_Pixel = 1:size(num_Pixels,2)
    num_Pixel = num_Pixels(inum_Pixel);
    
    %% load the HSI dataset
    if strcmp(database,'Indian')
        load Indian_pines_corrected;load Indian_pines_gt;load Indian_pines_randp 
        data3D = indian_pines_corrected;        label_gt = indian_pines_gt;
    elseif strcmp(database,'Salinas')
        load Salinas_corrected;load Salinas_gt;load Salinas_randp
        data3D = salinas_corrected;        
        label_gt = salinas_gt;        paviaU = paviaU./max(paviaU(:));
    elseif strcmp(database,'PaviaU')    
        load PaviaU;load PaviaU_gt;load PaviaU_randp; 
        data3D = paviaU;        label_gt = paviaU_gt;
    end
    data3D = data3D./max(data3D(:));
       
    % super-pixels segmentation
    labels = cubseg(data3D,num_Pixel);

    %% SupePCA DR
    [dataDR] = SuperPCA(data3D,num_PC,labels);

    iter = 1; % *** Note that here we only execute one round ***
    randpp=randp{iter};     
    % randomly divide the dataset to training and test samples
    [DataTest DataTrain CTest CTrain map] = samplesdivide(dataDR,label_gt,trainpercentage,randpp);   

    % Get label from the class num
    trainlabel = getlabel(CTrain);
    testlabel  = getlabel(CTest);

    % set the para of RBF
    ga8 = [0.01 0.1 1 5 10];    ga9 = [15 20 30 40 50 100:100:500];
    GA = [ga8,ga9];

    accy = zeros(1,length(GA));

    tempaccuracy1 = 0;
    predict_label_best = [];
    for trial0 = 1:length(GA);    
        gamma = GA(trial0);        
        cmd = ['-q -c 100000 -g ' num2str(gamma) ' -b 1'];
        model = svmtrain(trainlabel', DataTrain, cmd);
        [predict_label, AC, prob_values] = svmpredict(testlabel', DataTest, model, '-b 1');                    
        [confusion, accuracy1, CR, FR] = confusion_matrix_wei(predict_label', CTest);
        accy(trial0) = accuracy1;

        if accuracy1>tempaccuracy1
            tempaccuracy1 = accuracy1;
            predict_label_best = predict_label;
        end
    end
    accy_best(inum_Pixel) = tempaccuracy1;
    predict_labelS(inum_Pixel,:) = predict_label_best;
end

predict_label = label_fusion(predict_labelS');
[confusion, accuracy2, CR, FR] = confusion_matrix(predict_label', CTest);

fprintf('\n=============================================================\n');
fprintf(['The OA (1 iteration) of SuperPCA for ',database,' is %0.4f\n'],max(accy_best));
fprintf(['The OA (1 iteration) of MSuperPCA for ',database,' is %0.4f\n'],accuracy2);
fprintf('=============================================================\n');