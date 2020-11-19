function outimg = normalizeFace(lEye,rEye,image)
%NORMALIZEFACE Takes the positions of the eyes of a face in an image and
%the image, and returns a normalized version of the image.
%   
%   Normalisere ansiktet till en 271x221 bild genom att först rotera ögeonen
%   till x-axeln och sedan translateras vänsterögat till bildens center
%   förskutet med -50 och -25.

if (lEye == -1) | (rEye == -1)
    % We could make it so that if we can't find eyes, it normalizes around
    % the centroid of the masked face image.
    outimg = im2gray(image);
    return
end

image = rgb2gray(image);
[row , col] = size(image);

blackImage = zeros(row,col);
blackImage(lEye(2),lEye(1)) = 1;
%blackImage(round(Reye(2)),round(Reye(1))) = 1;
angle = rad2deg(atan2(rEye(2)-lEye(2),rEye(1)-lEye(1)));
image = imrotate(image,angle);
blackIM = imrotate(blackImage,angle);

[leyeRow,leyeCol] = find(blackIM == 1);
lEye = [leyeCol(1),leyeRow(1)];

[row , col,~] = size(image);
centerRow = floor(row/2); %Y
centerCol = floor(col/2); %X
eyePos = [ centerCol-50 centerRow-25];


T = eyePos - lEye;
lEye = eyePos;


outimg = imtranslate(image,T);
outimg = imcrop(outimg,[ lEye(1)-53 lEye(2)-90 220 270]);

end