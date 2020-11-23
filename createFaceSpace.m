function createFaceSpace(images)
%CREATEFACESPACE Summary of this function goes here
%   
%   Detailed explanation goes here

addpath(genpath(fileparts('Detection/')));
addpath(genpath(fileparts('Pictures/')));

normIm = detectFace(imread(images(1).name));
[m,n] = size(normIm);
normIm = reshape(normIm, m*n, 1);
faceMat = zeros(m*n, length(images));
faceMat(:,1) = normIm;

for i=2:length(images)
    normIm = detectFace(imread(images(i).name));
    normIm = reshape(normIm, m*n, 1);
    faceMat(:,i) = normIm;
end

meanFace = mean(faceMat, 2);
figure, imshow(reshape(meanFace, m, n));

A = faceMat - meanFace;
L = A'*A;
[V D] = eig(L);
U = A*V;


normU = zeros(size(U));
for i=1:length(images)
    normU(:,i) =  U(:,i)/norm(U(:,i));
%     normU(:,i) = U(:,i) - min(U(:,i));
%     normU(:,i) = normU(:,i) ./ max(normU(:,i));
    figure, imshow(reshape(normU(:,i), m, n), []);
end

W = normU'*A(:,1)

save('meanFace','meanFace');
save('faceSpace','W');
fprintf('Created meanFace.mat and faceSpace.mat \nfrom %d images', length(images));

end

