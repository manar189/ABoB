function normIm = detectFace(im)
%DETECTFACE Takes an image of a face and returns it normalized.
%   Detailed explanation goes here

imshow(im);
mouthPos(:) = ginput(1);
[lEye, rEye] = detectEyes(im, mouthPos);
normIm = 123;

end

