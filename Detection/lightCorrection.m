function out = lightCorrection(im, N)
%LIGHTCORRECTION White patch based on the top N% of luma used for lighting correction.

imYCBCR = rgb2ycbcr(im);

% Find threshold value for top 5% luma values
lums = reshape(imYCBCR(:,:,1), 1, []);
lums = sort(lums, 'descend');
thresh_idx = ceil(N * size(lums, 2));
lum_thresh = lums(thresh_idx);

% Find the gray values of the white patch
mask = imYCBCR(:,:,1) >= lum_thresh;
r = im(:,:,1);
g = im(:,:,2);
b = im(:,:,3);
rx = max(r(mask));
gx = max(g(mask));
bx = max(b(mask));

% Gain factors for R and B channels
alpha = gx / rx;
beta = gx / bx;

% Transform the original RGB image
% Note that this method could still use some work
out(:,:,1) = im(:,:,1) .* alpha;
out(:,:,2) = im(:,:,2);
out(:,:,3) = im(:,:,3) .* beta;
end