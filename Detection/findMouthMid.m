function mouthPos = findMouthMid(mouthMap)
%FINDMOUTHTMID Takes an mouth map and returns the position of the mouth.
%   
%   Detailed explanation goes here

SE = strel('disk', 10);
for i = 0.5:0.001:0.99
    thresholdedImage = (mouthMap >= 1-i);
    thresholdedImage = imclose(thresholdedImage, SE);

    [L, num] = bwlabel(thresholdedImage);
    if num > 4
        break
    end
end
% figure, imshow(thresholdedImage);

% We could add and check more properties to make the algorithm more robust
if num > 0
    P = regionprops(L,'Area', 'centroid');

    [~, index] = max([P.Area]);
    mouthPos = round(P(index).Centroid);
else
    % Returns -1 if no mouth was found
    mouthPos = [-1 -1];
end

end