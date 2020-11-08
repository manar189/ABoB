function [lEye,rEye] = detectEyes(im)
%DETECTEYES Takes an image of a face and returns the positions of the eyes.
%   Detailed explanation goes here

[n, m, ~] = size(im);
imYCBCR = im2double(rgb2ycbcr(im));

Y = imYCBCR(:,:,1);
Cb = imYCBCR(:,:,2);
Cr = imYCBCR(:,:,3);
eyeMapC = 1/3 * (Cb.^2 + (ones(n,m)-Cr).^2 + (Cb./Cr));
% figure, imshow(eyeMapC,[]);

SE = strel('disk', 5);
eyeMapL = imdilate(Y, SE) ./ (imerode(Y, SE)+1);
% figure, imshow(eyeMapL);

eyeMap = eyeMapC .* eyeMapL;
% figure, imshow(eyeMap,[]);

for i = 100:-1:0
    eyeMask = (eyeMap >= max(eyeMap(:))-(max(eyeMap(:))/i));
%     figure, imshow(eyeMask);
    eyeMask = imclose(eyeMask, SE);
%     figure, imshow(eyeMask);
    [L, num] = bwlabel(eyeMask);
    if(num == 2)
        
        P = regionprops(L,'Centroid');

        if(P(1).Centroid(1) <= P(2).Centroid(1))
            lEye = [round(P(1).Centroid(2)) round(P(1).Centroid(1))];
            rEye = [round(P(2).Centroid(2)) round(P(2).Centroid(1))];
        else
            lEye = [round(P(2).Centroid(2)) round(P(2).Centroid(1))];
            rEye = [round(P(1).Centroid(2)) round(P(1).Centroid(1))];
        end

        try
            im(lEye(1)-5:lEye(1)+5, lEye(2)-5:lEye(2)+5, 1) = 255;
            im(rEye(1)-5:rEye(1)+5, rEye(2)-5:rEye(2)+5, 1) = 255;
            im(lEye(1)-5:lEye(1)+5, lEye(2)-5:lEye(2)+5, 2:3) = 0;
            im(rEye(1)-5:rEye(1)+5, rEye(2)-5:rEye(2)+5, 2:3) = 0;
        catch
            e = "Error in detectEyes"
        end
        
        break
    else
        lEye = [0 0];
        rEye = [0 0];
    end
end


figure, imshow(im);

end

