function faceId = classifyFace(normIm)
%CLASSIFYFACE Takes a normalized image of a face and returns its id.
%   Detailed explanation goes here

if exist('../faceSpace.mat','file') && exist('../meanFace.mat','file')
    faceId = -1;
    fprintf('Missing file faceSpace.mat and/or meanFace.mat');
    return
end

load(fullfile('Projekt/', 'faceSpace.mat'));
load(fullfile('Projekt/', 'meanFace.mat'));
load(fullfile('Projekt/', 'weights.mat'));

[m,n] = size(normIm);
normIm = reshape(normIm, m*n, 1);

difference = normIm - meanFace;
projW = normU(:,10:16)'*difference;

[dist, faceId] = min(vecnorm(W(:,10:16) - projW))
