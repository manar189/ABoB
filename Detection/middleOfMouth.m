function [pos] = middleOfMouth(mouthImage)
%MIDDLEOFMOUTH Summary of this function goes here
%   returns the middle position of the mouth in the image mouthImage

%get the label for all 8 connected regions with the total area and their
%respective centeroids
[L, ~] = bwlabel(mouthImage);
P = regionprops(L,'Area', 'centroid');

%the largest connected area should be the mouth and thus we return the
%centeroid of the element in the index where the area is largest in the
%struct P, rounding the centeroid because coordinates cant be doubles
[~, index] = max([P.Area]);
pos = round(P(index).Centroid);

end

