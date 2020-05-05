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
addpath('.\libsvm-3.21\matlab');
addpath(genpath(cd));

num_PC           =   30;  % THE OPTIMAL PCA DIMENSION.
% num_Pixel        =   100; % THE OPTIMAL Number of Superpixel. Indian:100, PaviaU:20, Salinas:100
trainpercentage  =   30;  % Training Number per Class
iterNum          =   10;  % The Iteration Number

database         =   'Indian';

%% load the HSI dataset
if strcmp(database,'Indian')
    load Indian_pines_corrected;load Indian_pines_gt;load Indian_pines_randp 
    data3D = indian_pines_corrected;        label_gt = indian_pines_gt;
    num_Pixel        =   100;
elseif strcmp(database,'Salinas')
    load Salinas_corrected;load Salinas_gt;load Salinas_randp
    data3D = salinas_corrected;        label_gt = salinas_gt;
    num_Pixel        =   100;
elseif strcmp(database,'PaviaU')    
    load PaviaU;load PaviaU_gt;load PaviaU_randp; 
    data3D = paviaU;        label_gt = paviaU_gt;
    num_Pixel        =   20;
end
data3D = data3D./max(data3D(:));

%% super-pixels segmentation
labels = cubseg(data3D,num_Pixel);

%% SupePCA based DR
[dataDR] = SuperPCA(data3D,num_PC,labels);

for iter = 1:iterNum

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
    for trial0 = 1:length(GA);    
        gamma = GA(trial0);        
        cmd = ['-q -c 100000 -g ' num2str(gamma) ' -b 1'];
        model = svmtrain(trainlabel', DataTrain, cmd);
        [predict_label, AC, prob_values] = svmpredict(testlabel', DataTest, model, '-b 1');                    
        [confusion, accuracy1, CR, FR] = confusion_matrix(predict_label', CTest);
        accy(trial0) = accuracy1;
    end
    accy_best(iter) = max(accy);
end
fprintf('\n=============================================================\n');
fprintf(['The average OA (10 iterations) of SuperPCA for ',database,' is %0.4f\n'],mean(accy_best));
fprintf('=============================================================\n');
