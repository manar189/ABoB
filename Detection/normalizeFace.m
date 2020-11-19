function outimg = normalizeFace(Leye,Reye,image)
%Normaliserar ansiktet till en 271x221 bild genom att först rotera ögeonen
%till x-axeln och sedan translateras vänsterögat till bildens center
%förskutet med -50 och -25.
image = rgb2gray(image);
[row , col,~] = size(image);

blackImage = zeros(row,col);
blackImage(round(Leye(2)),round(Leye(1))) = 1;
%blackImage(round(Reye(2)),round(Reye(1))) = 1;
angle = rad2deg(atan2(Reye(2)-Leye(2),Reye(1)-Leye(1)));
image = imrotate(image,angle);
blackIM = imrotate(blackImage,angle);

[leyeRow,leyeCol] = find(blackIM == 1);
Leye = [leyeCol,leyeRow];
%Leye = [row1(1),col1(1)];
%Reye = [row1(2),col1(2)];

[row , col,~] = size(image);
centerRow = floor(row/2); %Y
centerCol = floor(col/2); %X
eyePos = [ centerCol-50 centerRow-25];


T = eyePos - Leye;
Leye = eyePos;


outimg = imtranslate(image,T);
outimg = imcrop(outimg,[ Leye(1)-53 Leye(2)-90 220 270]);


end