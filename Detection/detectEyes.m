function [lEye,rEye] = detectEyes(im)
%DETECTEYES Takes an image of a face and returns the positions of the eyes.
%   Detailed explanation goes here

colorMap = colorEyeMap(im);
% figure, imshow(colorMap);

houghMap = houghEyeMap(im);
% figure, imshow(houghMap);

eyeMap = colorMap.*houghMap + (colorMap+houghMap)/2;
figure, imshow(eyeMap);
lEye = 123;
rEye = 321;

end

