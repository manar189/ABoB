function [mouthMask, middleOfMouth] = detectMouth(inImage)
% DETECTMOUTH en funktoin för att upptäcka ansikten
% Detailed explanation goes here
inImage2 = im2double(inImage);
YCbCrImg = rgb2ycbcr(inImage2);

Cb = YCbCrImg(:,:,2);
Cr = YCbCrImg(:,:,3);

CrDivCb = Cr./Cb;

CrSq = Cr.*Cr;

Difference = CrDivCb - CrSq;

MouthMap = Difference .* CrSq;

%find the max value in the image
[x, y] = find(ismember(MouthMap, max(MouthMap(:))));
MouthMap(x, y) = 1.0;
SE = strel('disk', 3);
MouthMap = imdilate(MouthMap, SE);

MouthMap = MouthMap == 1.0;

outImage = inImage + MouthMap;

mouthMask = outImage;
middleOfMouth = [300, 300];

end

