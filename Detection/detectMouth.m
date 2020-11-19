function mouthPos = detectMouth(inImage)
%DETECTMOUTH Takes an image of a face and returns the position of the mouth.
%
%    Detailed explanation goes here

% convert image -> double -> YCbCr color space
yCbCrImg = rgb2ycbcr(im2double(inImage));

% get the respective channels Cb & Cr
cb = yCbCrImg(:,:,2);
cr = yCbCrImg(:,:,3);

% the rest follows the formula in lecture 2 slide 53
crDivWithCb = cr./cb;
crSquared = cr.^2;

% numel = tot elements in inImage, n = 1/n in formula from lecture
n = (1/numel(inImage));

% greek letter eta from the formula in lecture 2
eta = 0.95*(n*sum(crSquared))/(n*sum(crDivWithCb));

difference = (crSquared - eta*crDivWithCb).^2;
mouthMap = crSquared .* difference;

% stretching the image since we get values under 0.048 without stretching
% after stretch the values range between 0-1
minIm = min(mouthMap(:));
maxIm = max(mouthMap(:));
mouthMap = (mouthMap-minIm)/(maxIm-minIm);
% figure, imshow(mouthMap);

mouthPos = findMouthMid(mouthMap);

% UNCOMMENT TO SEE RESULT
% if mouthPos(1) ~= -1
%     figure, imshow(inImage);
%     viscircles(mouthPos, 12);
% else
%     fprintf('No mouth detected');
% end

end


