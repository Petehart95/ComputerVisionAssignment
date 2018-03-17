% CMP9135M - Computer Vision - Assessment Item 1 - 12421031 - Peter Hart

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 3: Object Tracking %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear; clc; % Reset environment

currentDir = pwd; % Get the current directory
aDir = strcat(currentDir,'\dataset\a.csv'); % Save input file locations
bDir = strcat(currentDir,'\dataset\b.csv');
xDir = strcat(currentDir,'\dataset\x.csv');
yDir = strcat(currentDir,'\dataset\y.csv');

a = csvread(aDir);b = csvread(bDir); % Load real coordinates
x = csvread(xDir);y = csvread(yDir); % Load noisy coordinates


% end of script