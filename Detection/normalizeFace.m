function [outimg,Leye,Reye] = normalizeFace(Leye,Reye,image,eyePos)



T = eyePos - Leye;
Leye = eyePos;
Reye = Reye + T;


outimg =imtranslate(image,T);
%outimg = imrotate(image,angle);

end