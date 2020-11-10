function outIm = detectFaceEdge(im)
%DETECTFACEEDGE Takes an image of a face and returns a mask of the most
%likely face.
%   Detailed explanation goes here

imGray = im2double(rgb2gray(im));
imEdge = edge(imGray, 'Canny');
% figure, imshow(imEdge);

[centers, rad] = imfindcircles(imGray, [1 50])

for i=1:length(centers)
    RGB = insertShape(imGray, 'Circle', [round(centers(i,1)) ...
        round(centers(i,2)) round(rad(i))], 'LineWidth', 5);
%     figure, imshow(RGB);
end

outIm = 123321;
end

