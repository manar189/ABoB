function [mouthMid] = findMouthMid(mouthMap, skinMask)
%GETMOUTHTHRESHOLD Summary of this function goes here
%   will return the position of the middle of the mouth using the mouthMap

SE = strel('disk', 15);
newAttempt = true;
num = 0;

for i = 100:-2:2
    thresholdedImage = (mouthMap >= max(mouthMap(:))-(max(mouthMap(:))/i));
    %thresholdedImage = imopen(thresholdedImage, SE);
    thresholdedImage = imclose(thresholdedImage, SE);
    %figure, imshow(thresholdedImage);
    [~, num] = bwlabel(thresholdedImage);
    if num > 4
        newAttempt = false;
        break;
    end
end

% % fix for a second robustness criterion for images that cant separate 4
% patches of mouthiness

% % new attetmpt to find the mouth, this is if the prev fails
% if newAttempt || num == 0
%     
% end
% 
% temp = middleOfMouth(thresholdedImage);
% %middle of mouth was placed wrong -> we need to try again hehe
% % not done at all dont believe the crap i wrote here :)
% if temp(1) < round(mouthMap(1)/2)
%     
% end

% middle of mouth is finished and could actually be moved into this
% function
mouthMid = middleOfMouth(thresholdedImage);

% %uncomment to see result

% figure, imshow(thresholdedImage);

% k = zeros(size(thresholdedImage));
% k(mouthMid(2), mouthMid(1)) = 1;
% SE = strel('disk', 10);
% k = imdilate(k, SE);
% figure, imshow(skinMask + k);



end

%% general idea
%lite open operation -> blev close
%hitta egenskaper f�r munnen
%bwlabel, regionprops
%sen centeroid p� mun

%% old code

%assume mouth will not be near the edges of the face and will be in the bottom
%half of it
% [topRow, rightCol, bottomRow, leftCol] = headIndex(skinMask);

% % 15% from left to right
% tenPercentCols = ceil(0.1*(rightCol-leftCol));
% %the sideframes of the possible mouth area
% leftThresh = leftCol + tenPercentCols;
% rightThresh = rightCol - tenPercentCols;

% 15% from bottom to top
% fifteenPercentRows = ceil(0.15*(bottomRow-topRow));
%half from top to bottom
% halfOfHead = (bottomRow - topRow)/2;
% topThresh = ceil(topRow + halfOfHead);
% bottomThresh = bottomRow - fifteenPercentRows;


% imageAfterClose(topThresh, :) = 1;
% imageAfterClose(bottomThresh, :) = 1;
% imageAfterClose(:, leftThresh) = 1;
% imageAfterClose(:, rightThresh) = 1;

% %top and bottom
%imageAfterClose(1:topThresh,:) = 0;

%% old code 

% old code
% [numRows, numCols] = size(imageAfterClose);
% topHalfRows = ceil(numRows/2);
% twentyPercentColumns = ceil(numCols*0.2);
% tenPercentRows = ceil(numRows*0.1);
% 
% %sides
% imageAfterClose(:,1:twentyPercentColumns) = 0;
% imageAfterClose(:, numCols - twentyPercentColumns : numCols) = 0;
% 
% %top and bottom
% imageAfterClose(1:topHalfRows,:) = 0;
% imageAfterClose(numRows - tenPercentRows : numRows,:) = 0;
% 
% bwMouthOnly = imageAfterClose;