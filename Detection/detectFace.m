function normIm = detectFace(im)
%DETECTFACE Takes an image of a face and returns it normalized.
%   
%   The function tries to identify skin and masks the image after what
%   likely is skin. It then detects the mouth by color transformations and
%   the eyes by color- and circular hough-transformations. A normalized
%   image is cropped, turned gray and has the left eye in a fixed position. 

load skinTones.mat P % P is pre-fit and cached with the skin tone samples

imCorr = lightCorrection(im, 0.02);
[imSkin, skinMask] = detectSkin(imCorr, P);

% figure, imshow(im);
% figure, imshow(imSkin);
% figure, imshow(skinMask);

% Removes smal artifacts from skinMask. This should maybe be done in
% detectSkin-function
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
normIm = normalizeFace(lEye, rEye, im);



end

