% CMP9135M - Computer Vision - Assessment Item 1 - 12421031 - Peter Hart

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 1: Image Segmentation %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear; clc; % Reset environment

currentDir = pwd;

% Dialog box for file selection (filter = .jpg,.png)
[fileNames, pathName, filterIndex] = uigetfile({'*.jpg;*.png;*.bmp;','All Image Files';'*.*','All Files'},'Select Input Images for Superpixel segmentation','MultiSelect', 'on');

% Check if only one file is selected
if ~iscell(fileNames)
    fileNames = {fileNames}; % If only one file is selected, ensure the file name is cell and not character
end 

for fileid=1:length(fileNames)
    selectedFile = strcat(pathName,char(fileNames(fileid))); 
    im1 = imread(selectedFile); 
    im = imgaussfilt(im1);
    figure;
    histogram(im);
    % Get tray segmentation
    im_histeq = histeq(im);
    figure;
    histogram(im_histeq);
    level = graythresh(im_histeq);
    BW = imbinarize(im_histeq,level);
    se = strel('square',8);
    BW_open = imopen(BW,se);

    rprops = regionprops(BW_open,'BoundingBox'); %Establish a bounding box
    bbox = rprops.BoundingBox; %surround superpixel with bounding box

    imTrayCropped = imcrop(im, bbox); %crop the original image based on this mask  
   
    % Get label segmentation
    
    im2 = imTrayCropped;

    level = graythresh(im2);
    BW2 = imbinarize(im2,level);
    se1 = strel('disk',19);
    se2 = strel('disk',28);
    BW2_open = imerode(BW2,se1);
    BW2_open = imdilate(BW2_open,se2);
    figure;
    imshow(BW2_open);
    L = bwlabel(BW2_open);
    highestArea = 0;
    M = zeros(size(BW2_open));
    label = zeros(size(M));
    for i=1:max(max(L))
        M = zeros(size(BW2_open));
        M = L == i; 
        
        rprops = regionprops(M,'BoundingBox'); %Establish a bounding box
        bbox = rprops.BoundingBox; %surround superpixel with bounding box
        
        width = bbox(3); height = bbox(4);
        area = width * height;
        if area > highestArea
            highestArea = area;
            label = M;
            labelbbox = bbox;
        end
    end
    
    imLabelCropped = imcrop(imTrayCropped, labelbbox); %crop the original image based on this mask  

    
    %output results
    figure;
    subplot(2,2,1); imshow(im); title('Original');
    subplot(2,2,2); imshow(BW_open); title('Binary Segmentation Mask');
    subplot(2,2,3); imshow(imTrayCropped); title('Segmented Tray');
    subplot(2,2,4); imshow(imLabelCropped); title('Segmented Label');
end
% end of script