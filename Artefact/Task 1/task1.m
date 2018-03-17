% CMP9135M - Computer Vision - Assessment Item 1 - 12421031 - Peter Hart

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 3: Image Segmentation %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear; clc; % Reset environment

currentDir = pwd;
file1Dir = strcat(currentDir,'\dataset\Topimage0000.bmp');
file2Dir = strcat(currentDir,'\dataset\Topimage0013.bmp');

im1 = imread(file1Dir);
im2 = imread(file2Dir);

% end of script