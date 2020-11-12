function normIm = detectFace(im)
%DETECTFACE Takes an image of a face and returns it normalized.
%   Detailed explanation goes here

load skinTones.mat P % P is pre-fit and cached with the skin tone samples
imCorr = lightCorrection(im, 0.02);
[imSkin, skinMask] = detectSkin(imCorr, P);
% figure, imshow(imSkin);
% figure, imshow(skinMask);

% This should be done in detectSkin-function
SE = strel('disk', 100);
skinMask = imopen(skinMask, SE);
imMask = im2double(im).*skinMask;

% Replace for detectMouth-function
figure, imshow(im);
mouthPos(:) = ginput(1);

% Detects eyes and returns their positions
[lEye, rEye] = detectEyes(imMask, mouthPos);

% Replace for normalization-function
normIm = 123;

end

