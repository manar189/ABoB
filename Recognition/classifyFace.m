function faceId = classifyFace(normIm)
%CLASSIFYFACE Takes a normalized image of a face and returns its id.
%   Detailed explanation goes here

fisherThresh = 150;

%%% ==================== USING EIGENFACES ==================== %%%
% if exist('../faceSpace.mat','file') && exist('../meanFace.mat','file')
%     faceId = -1;
%     fprintf('Missing file faceSpace.mat and/or meanFace.mat');
%     return
% end
% 
% load(fullfile('faceSpace.mat'));
% load(fullfile('meanFace.mat'));
% load(fullfile('weights.mat'));
% 
% [m,n] = size(normIm);
% normIm = reshape(normIm, m*n, 1);
% 
% difference = normIm - meanFace;
% projW = normU(:,4:14)'*difference;
% 
% [dist, faceId] = min(vecnorm(W(4:14,:) - projW))

%%% =================== USING FISHER FACES =================== %%%
if exist('../fisher.mat','file')
    faceId = -1;
    fprintf('Missing file fisher.mat');
    return
end

load('fisher.mat')

[m,n] = size(normIm);
normIm = reshape(normIm, m*n, 1);

projW = F'*normIm;

[dist, faceId] = min(vecnorm(muW - projW));
if dist > fisherThresh
   faceId = 0; 
end

end