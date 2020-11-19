function normIm = detectFace(im)
%DETECTFACE Takes an image of a face and returns it normalized.
%   Detailed explanation goes here

% figure, imshow(im);
load skinTones.mat P % P is pre-fit and cached with the skin tone samples

% Probably needs fixing. Can't see any difference from im in most images
% and creates error for DB2\il_01 and DB2\il_12
% imCorr = lightCorrection(im, 0.02);
% figure, imshow(imCorr);
imCorr = im;    % TEMPORARY, FIX lightCorrection

[imSkin, skinMask] = detectSkin(imCorr, P);
% figure, imshow(imSkin);
% figure, imshow(skinMask);

% This should be done in detectSkin-function
SE = strel('disk', 100);
skinMask = imopen(skinMask, SE);
imMask = im2double(im).*skinMask;
% figure, imshow(skinMask);

% Detects mouth in image and returns its position
mouthPos = detectMouth(imMask);


% Detects eyes in image, takes mouth position as argument
% and returns the eyes positions
[lEye, rEye] = detectEyes(imMask, mouthPos);

% Replace for normalization-function
normIm = 12321;



end

