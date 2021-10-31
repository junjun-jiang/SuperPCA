clc
clear
close all

database = 'KSC';

load([database '_gt.mat']);

gth = KSC_gt;

IterNum = 10;
randp = randpGen(gth,IterNum);
save([database '_gt_randp.mat']);

