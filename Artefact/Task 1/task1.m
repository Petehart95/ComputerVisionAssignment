close all; clear; clc;

currentDir = pwd;
datasetDir = '\dataset\';
file1Dir = strcat(currentDir,datasetDir,'Topimage0000.bmp');
file2Dir = strcat(currentDir,datasetDir,'Topimage0013.bmp');

im1 = imread(file1Dir);
im2 = imread(file2Dir);

