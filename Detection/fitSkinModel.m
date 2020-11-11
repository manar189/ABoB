function P = fitSkinModel(skinTones)
%FITSKINMODEL Creates a Gaussian PDF fit to the given skin tone samples.
%The return value P(x) is a function handle used to evaluate a given color
%vector in the CbCr color subspace.

skinTones = rgb2ycbcr(skinTones);
skinCb = skinTones(:, 2);
skinCr = skinTones(:, 3);

skinMean = mean([skinCb skinCr])';
skinCov = cov([skinCb skinCr]) + [0.006 0; 0 0.0025];

P = @(x) exp(-0.5 * (x - skinMean)' * inv(skinCov) * (x - skinMean));
end

