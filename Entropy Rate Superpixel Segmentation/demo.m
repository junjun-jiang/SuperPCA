%//
%// MATLAB wrapper for Entropy Rate Superpixel Segmentation
%//
%// This software is used to demo the entropy rate superpixel
%// segmentation algorithm (ERS). The detailed of the algorithm can be
%// found in 
%//
%//      Ming-Yu Liu, Oncel Tuzel, Srikumar Ramalingam, Rama Chellappa,
%//      "Entropy Rate Superpixel Segmentation", CVPR2011.
%//
%// Copyright 2011, Ming-Yu Liu <mingyliu@umiacs.umd.edu>
%
close all;clear all;clc

disp('Entropy Rate Superpixel Segmentation Demo');

%%
%//=======================================================================
%// Input
%//=======================================================================
%// These images are duplicated from the Berkeley segmentation dataset,
%// which can be access via the URL
%// http://www.eecs.berkeley.edu/Research/Projects/CS/vision/bsds/
%// We use them only for demonstration purposes.

% img = imread('148089.jpg');
img = imread('242078.jpg');

%// We convert the input image into a grey scale image for superpixel
%// segmentation.
grey_img = double(rgb2gray(img));

%%
%//=======================================================================
%// Superpixel segmentation
%//=======================================================================
%// nC is the target number of superpixels.
nC = 300;
%// Call the mex function for superpixel segmentation\
%// !!! Note that the output label starts from 0 to nC-1.
t = cputime;
[labels] = mex_ers(grey_img,nC);
fprintf(1,'Use %f sec. \n',cputime-t);
fprintf(1,'\t to divide the image into %d superpixels.\n',nC);

%// You can also specify your preference parameters. The parameter values
%// (lambda_prime = 0.5, sigma = 5.0) are chosen based on the experiment
%// results in the Berkeley segmentation dataset.
%// lambda_prime = 0.5; sigma = 5.0;
%// [out] = mex_ers(grey_img,nC,lambda_prime,sigma);

%%
%//=======================================================================
%// Output
%//=======================================================================
[height width] = size(grey_img);

%// Compute the boundary map and superimpose it on the input image in the
%// green channel.
%// The seg2bmap function is directly duplicated from the Berkeley
%// Segmentation dataset which can be accessed via
%// http://www.eecs.berkeley.edu/Research/Projects/CS/vision/bsds/
[bmap] = seg2bmap(labels,width,height);
bmapOnImg = img;
idx = find(bmap>0);
timg = grey_img;
timg(idx) = 255;
bmapOnImg(:,:,2) = timg;
bmapOnImg(:,:,1) = grey_img;
bmapOnImg(:,:,3) = grey_img;

%// Randomly color the superpixels
[out] = random_color( double(img) ,labels,nC);

%// Compute the superpixel size histogram.
siz = zeros(nC,1);
for i=0:(nC-1)
    siz(i+1) = sum( labels(:)==i );
end
[his bins] = hist( siz, 20 );

%%
%//=======================================================================
%// Display 
%//=======================================================================
gcf = figure(1);
subplot(2,3,1);
imshow(grey_img,[]);
title('input grey scale image.');
subplot(2,3,2);
imshow(bmapOnImg,[]);
title('superpixel boundary map');
subplot(2,3,3);
imshow(out,[]);
title('randomly-colored superpixels');
subplot(2,3,5);
bar(bins,his,'b');
title('the distribution of superpixel size');
ylabel('# of superpixels');
xlabel('superpixel sizes in pixel');
scnsize = get(0,'ScreenSize');
set(gcf,'OuterPosition',scnsize);