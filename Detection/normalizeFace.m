function outIm = normalizeFace(lEye,rEye,im)
%NORMALIZEFACE Takes the positions of the eyes of a face in an image and
%the image, and returns a normalized version of the image.
%   
%   Detailed explanation goes here

if (lEye == -1) | (rEye == -1)
    % We could make it so that if we can't find eyes, it normalizes around
    % the centroid of the masked face image.
    outIm = im2gray(im);
    return
end

targetSize = [440 300];     % Size of output image
targetEyeDistance = 150;    % Scales the image so eyes are this far apart
im = rgb2gray(im2double(im));
[m,n] = size(im);

eyeDist = pdist([lEye(1) lEye(2); rEye(1) lEye(2)], 'cityblock');
angle = rad2deg(atan2(rEye(2)-lEye(2),rEye(1)-lEye(1)));

% Rotate around image centrum
im = imrotate(im,angle,'bilinear','crop');
% figure, imshow(im);

% Transformation matrix of the rotation
T1 = [1 0 (n/2);
      0 1 (m/2);
      0 0 1];
R = [cosd(angle) sind(angle) 0;
     -sind(angle) cosd(angle) 0;
     0 0 1];
T2 = [1 0 -(n/2);
      0 1 -(m/2);
      0 0 1];
M1 = T1*R*T2;
% Transforms eye coordinates to new position
lEye = round(M1*[lEye 1]')';
% rEye = round(M1*[rEye 1]')';

% Translates face to center of image
im = imtranslate(im, [-lEye(1)+n/2-eyeDist/2 -lEye(2)+m/2-eyeDist/4]);
% figure, imshow(im);

% Scales image so face is same size on all images
scale = targetEyeDistance / eyeDist;
im = imresize(im,scale);
% figure, imshow(im);

% Crops image to target size
crop = centerCropWindow2d(size(im),targetSize);
outIm = imcrop(im, crop);

end