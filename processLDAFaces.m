% Cropped image dimensions
w = 300;
h = 400;

% Process all files
allFiles = dir("Pictures\LDA\*\*.jpg");
N = length(allFiles);
faces = zeros(w*h, N);

for n=1:N
    im = im2double(imread(allFiles(n).name));
    faces(:, n) = reshape(detectFace(im), [], 1);
end

meanAll = mean(faces, 2);
imshow(histeq(reshape(meanAll, h, w)))

save('trainingFaces.mat', 'faces', 'meanAll')