% CMP9135M - Computer Vision - Assessment Item 1 - 12421031 - Peter Hart

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 2: Feature Calculation %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear; clc; % Reset environment

% Load image
currentDir = pwd; fileDir = '\dataset\ImgPIA.jpeg';
selectedFile = strcat(currentDir,fileDir);

% Image Preprocessing
input_im_256 = imread(selectedFile);
input_im_256 = rgb2gray(input_im_256);

figure;imshow(input_im_256);
rect = getrect;
im = imcrop(input_im_256,rect);
close;

% Begin operations
figure;
subplot(2,3,1);
imshow(im,[]);
title('Original Selection');

% Compute Fourier Transform
F = fft2(im,256,256); 
subplot(2,3,2); imshow(F); title('Fourier Transform');

% Center FFT
F = fftshift(F); 
subplot(2,3,3); imshow(F); title('Centred Fourier Transform');

% Measure the minimum and maximum value of the transform amplitude
subplot(2,3,4); imshow(abs(F),[0 100]); colormap(jet); colorbar; title('Min and Max of the Transform Amplitude');

% Logarithm amplitude
logF = log(1+abs(F));
subplot(2,3,5); imagesc(logF); colormap(jet); colorbar; title('Logarithmic Transform');

% Phases
angularF = angle(F);
subplot(2,3,6); imshow(angularF,[-pi,pi]); colormap(jet); colorbar; title('Angular Phases');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Task 2 : Part 1

figure;
n = 1; r = 100; angleInterval = 45;
for i=0:angleInterval:135
    FMasked = logF;   
    angularMask = getAngleMask(logF,i,i+angleInterval);
    FMasked(~angularMask) = 0;
    total = sum(sum(FMasked));
    subplot(2,2,n); imshow(FMasked,[]); title(strcat("Angle ", num2str(i), "? - ", num2str(i+angleInterval), "? : Magnitude: ", num2str(total))); axis equal; grid on;
    n = n + 1;    
end

figure;
n = 1; distanceInterval = 25;
for i=25:distanceInterval:100
    FMasked = logF;   
    radiusMask = getRadiusMask(logF,i);
    FMasked(~radiusMask) = 0;
    total = sum(sum(FMasked));
    subplot(2,2,n); imshow(FMasked,[]); title(strcat("Radius ", num2str(i)," : Magnitude: ", num2str(total))); axis equal; grid on;
    n = n + 1;    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Task 2 : Part 2

[pixelCounts, GLs] = imhist(input_im_256);

% Get the number of pixels in the histogram.
numberOfPixels = sum(pixelCounts);

% Get the mean gray lavel.
meanGL = sum(GLs .* pixelCounts) / numberOfPixels;
% Get the variance, which is the second central moment.
varianceGL = sum((GLs - meanGL) .^ 2 .* pixelCounts) / (numberOfPixels-1);
% Get the standard deviation.
stdDev = sqrt(varianceGL);
% Get the skew.
skew = sum((GLs - meanGL) .^ 3 .* pixelCounts) / ((numberOfPixels - 1) * stdDev^3);
% Get the kurtosis.
kurtosis = sum((GLs - meanGL) .^ 4 .* pixelCounts) / ((numberOfPixels - 1) * stdDev^4);

GLCM256 = graycomatrix(input_im_256, 'offset', [0 1],'NumLevels', 256, 'Symmetric', true);
GLCM32 = graycomatrix(input_im_256, 'offset', [0 1],'NumLevels', 32, 'Symmetric', true);
GLCM16 = graycomatrix(input_im_256, 'offset', [0 1],'NumLevels', 16, 'Symmetric', true);
GLCM8 = graycomatrix(input_im_256, 'offset', [0 1],'NumLevels', 8, 'Symmetric', true);

stats_256 = GLCM_Features1(GLCM256,0);
stats_32 = GLCM_Features1(GLCM32,0);
stats_16 = GLCM_Features1(GLCM16,0);
stats_8 = GLCM_Features1(GLCM8,0);

function radiusMask = getRadiusMask(F,radius)
    radiusMask = false(size(F));
    totalRows = size(F,1); totalCols = size(F,2);
    centreX = round(totalRows / 2); centreY = round(totalCols/ 2);
    % Create circle based on input radius
    [imageSizeX, imageSizeY] = meshgrid(1:totalRows, 1:totalCols);
    radiusMask =  (imageSizeX - centreX).^2 + (imageSizeY- centreY).^2 <= radius.^2;
end

function angularMask = getAngleMask(F,angMin,angMax)
    angularMask = false(size(F));
    totalRows = size(F,1); totalCols = size(F,2);
    centreX = round(totalCols/2); centreY = round(totalRows/2); 
    angMin = deg2rad(angMin); angMax = deg2rad(angMax);
    for i=1:totalRows
        for j=1:totalCols
            ang = atan2(i-centreY,j-centreX);
            if ang > angMin && ang < angMax
                angularMask(i,j) = true;
            end
        end
    end
end

% end of script