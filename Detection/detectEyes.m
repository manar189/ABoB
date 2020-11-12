function [lEye,rEye] = detectEyes(im, mouth)
%DETECTEYES Takes an image of a face and returns the positions of the eyes.
%   Detailed explanation goes here

% Detecting possible eyes from colormaping
colorMap = colorEyeMap(im, mouth);
% figure, imshow(colorMap);

% Detecting possible eyes from circular hought-ransform
houghMap = houghEyeMap(im, mouth);
% figure, imshow(houghMap);

% Creates a probability-map from the above methods
eyeMap = colorMap.*houghMap + (colorMap+houghMap)/2;
% figure, imshow(eyeMap);

% Removing false positives from edge of face
%*******************THIS SHOULD BE IMPROVED*****************
grayIm = im2gray(im);
faceMask = zeros(size(grayIm));
faceMask(grayIm > 0) = 1;
SE = strel('diamond', 40);
faceMask = imerode(faceMask, SE);
eyeMap = eyeMap.*faceMask;
% figure, imshow(eyeMap);

twoEyes = zeros(size(grayIm));
u = unique(eyeMap);


for i = 0:length(u)
    twoEyes(eyeMap == u(end-i)) = 1;
    [L, num] = bwlabel(twoEyes);
    if(num >= 2)
        break
    end
end
%************************************************************

% figure, imshow(im + (L == 1) + (L == 2));

% Creates the resulting eye-positions from label properties
P = regionprops(L,'Centroid');
if(P(1).Centroid(1) < P(2).Centroid(1))
    lEye = uint16(P(1).Centroid);
    rEye = uint16(P(2).Centroid);
else
    lEye = uint16(P(2).Centroid);
    rEye = uint16(P(1).Centroid);
end

end

