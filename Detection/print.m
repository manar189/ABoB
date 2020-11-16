function [Leye,Reye] = print(image)
eyePos = [324 253];
imshow(image);
Leye = ginput(1);
Reye = ginput(1);
close
[outimg,Leye,Reye] = normalizeFace(Leye,Reye,image,eyePos);
figure

imshow(outimg)
hold on
plot(Leye(1),Leye(2),'c+', 'MarkerSize', 50);
%plot(Reye(1),Reye(2),'r+', 'MarkerSize', 50);
end