function [lEye,rEye] = detectEyes(im, mouth)
%DETECTEYES Takes an image of a face and returns the positions of the eyes.
%   Detailed explanation goes here

colorMap = colorEyeMap(im, mouth);
% figure, imshow(colorMap);

houghMap = houghEyeMap(im, mouth);
% figure, imshow(houghMap);

eyeMap = colorMap.*houghMap + (colorMap+houghMap)/2;
% figure, imshow(eyeMap);

u = unique(eyeMap);
eyes = (eyeMap == u(end) | eyeMap == u(end-1));
figure, imshow(im2double(im) + eyes);

lEye = 123;
rEye = 321;

end

