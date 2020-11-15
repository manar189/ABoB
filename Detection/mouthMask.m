function [bwMouthOnly, thresholdedImage] = mouthMask(bildDouble)
%GETMOUTHTHRESHOLD Summary of this function goes here
%   Detailed explanation goes here

% %find the max value in the image
% [x, y] = find(ismember(MouthMap, max(MouthMap(:))));
% MouthMap(x, y) = 1.0;
% SE = strel('disk', 5);
% MouthMap = imdilate(MouthMap, SE);

thresholdedImage = bildDouble >= 0.4;
SE = strel('disk', 2);
imageAfterOpen = imopen(thresholdedImage, SE);
imageAfterClose = imclose(imageAfterOpen, SE);

%assume mouth will not be near the edges of the image and in the bottom
%half
[numRows, numCols] = size(imageAfterClose);
topHalfRows = ceil(numRows/2);
twentyPercentColumns = ceil(numCols*0.2);
tenPercentRows = ceil(numRows*0.1);
%sides
imageAfterClose(:,1:twentyPercentColumns) = 0;
imageAfterClose(:, numCols - twentyPercentColumns : numCols) = 0;

%top and bottom
imageAfterClose(1:topHalfRows,:) = 0;
imageAfterClose(numRows - tenPercentRows : numRows,:) = 0;

bwMouthOnly = imageAfterClose;

%lite open operation
%hitta egenskaper för munnen
%bwlabel, regionprops
%sen centeroid på mun

end

