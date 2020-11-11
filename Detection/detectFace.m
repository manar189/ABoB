function normIm = detectFace(im)
%DETECTFACE Takes an image of a face and returns it normalized.
%   Detailed explanation goes here

load skinTones.mat P % P is pre-fit and cached with the skin tone samples
imCorr = lightCorrection(im, 0.02);
[imSkin, skinMask] = detectSkin(imCorr, P);

imshow(im);
mouthPos(:) = ginput(1);
[lEye, rEye] = detectEyes(im, mouthPos);

normIm = 123;

end

