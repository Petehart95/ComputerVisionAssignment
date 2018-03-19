% CMP9135M - Computer Vision - Assessment Item 1 - 12421031 - Peter Hart

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 3: Image Segmentation %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear; clc; % Reset environment

currentDir = pwd;
file1Dir = strcat(currentDir,'\dataset\TopImg0000.bmp');
file2Dir = strcat(currentDir,'\dataset\TopImg0013.bmp');

im1 = imread(file1Dir);
im2 = imread(file2Dir);

    
max_luminosity = 100; 
threshold = 254;

srgb2lab = makecform('srgb2lab');
lab2srgb = makecform('lab2srgb');
im_lab = applycform(im1, srgb2lab);

L = im_lab(:,:,1)/max_luminosity;

im_adapthisteq = im_lab;
im_adapthisteq(:,:,1) = adapthisteq(L)*max_luminosity;
im_adapthisteq = applycform(im_adapthisteq,lab2srgb);

im_greyscale = im_adapthisteq(:,:,1);
im_bi = rgb2bi(im_greyscale,threshold);    
im_bi = imfill(im_bi,'holes'); 

imshow(im_bi);
% end of script