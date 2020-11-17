function [imSkin, skinMask] = detectSkin(im, P)
%DETECTSKIN Calculate the probability of each pixel in im being skin by using the PDF given in P which models skin color.
%Returns both the probability image and a binarized mask image.

[n, m,~] = size(im);
imDims = [n, m];
imYCBCR = im2double(rgb2ycbcr(im));
imSkin = zeros(imDims);

% Apply the model with this ugly for loop, eww
% This was the best I could do, feel free to tidy it up
for n1 = 1:imDims(1)
    for n2 = 1:imDims(2)
        imSkin(n1, n2) = P([imYCBCR(n1, n2, 2); imYCBCR(n1, n2, 3)]);
    end
end

% Low pass filtering for smoothing, might be nice to try using
% morpholigical operations for this instead
H = fspecial('gaussian', 20, 2.5);
imFilt = imfilter(imSkin, H, 'replicate');

% Thresholding with Otsu's method to create the mask
[counts, ~] = imhist(imFilt);
T = otsuthresh(counts);
skinMask = imbinarize(imFilt, T);

% Setting the optional argument to 'union' will return a single blob rather
% than the multiple blobs from 'objects'
% skinMask = bwconvhull(skinMask, 'objects');
SE = strel('disk', 30);
skinMask = imclose(skinMask, SE);
end

