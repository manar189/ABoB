function [lEye,rEye] = detectEyes(im, mouth, skinMask)
%DETECTEYES Takes an image of a face and returns the positions of the eyes.
%   
%   Detailed explanation goes here

lEye = -1;
rEye = -1;

hasSkinMask = sum(skinMask,'all') > 0;

skinIm = im2double(im).*skinMask;

SE = strel('disk',16);
removeEdgeCent = skinMask > 0;
removeEdgeCent = imerode(removeEdgeCent, SE);
% figure, imshow(removeEdgeCent);

% Detecting possible eyes from colormaping
[colorMap1, colorCent1] = colorEyeMap(im, mouth);
[colorMap2, colorCent2] = colorEyeMap(im, [-1, -1]);
[colorMap3, colorCent3] = colorEyeMap(skinIm, mouth);
[colorMap4, colorCent4] = colorEyeMap(skinIm, [-1, -1]);

if hasSkinMask
    colorMap = colorMap1.*colorMap2.*skinMask/2 + colorMap1.*colorMap2.*colorMap3.*colorMap4 + ...
          (colorMap1+colorMap2+colorMap3+colorMap4)/4;
    colorCent = unique([colorCent1; colorCent2; colorCent3; colorCent4],'rows');
else
    colorMap = colorMap1.*colorMap2 + (colorMap1+colorMap2)/2;
    colorCent = unique([colorCent1; colorCent2],'rows');
end
% figure, imshow(colorMap);

% Detecting possible eyes from circular hought-ransform
[houghMap1, houghCent1] = houghEyeMap(im, mouth);
[houghMap2, houghCent2] = houghEyeMap(im, [-1, -1]);
[houghMap3, houghCent3] = houghEyeMap(skinIm, mouth);
[houghMap4, houghCent4] = houghEyeMap(skinIm, [-1, -1]);
houghMap3 = houghMap3.*removeEdgeCent;
houghMap4 = houghMap4.*removeEdgeCent;

if hasSkinMask
    houghMap = houghMap1.*houghMap2.*skinMask + houghMap1.*houghMap2.*houghMap3.*houghMap4 + ...
          (houghMap1+houghMap2+houghMap3+houghMap4)/4;
    houghCent = unique([houghCent1; houghCent2; houghCent3; houghCent4],'rows');
else
    houghMap = houghMap1.*houghMap2 + (houghMap1+houghMap2)/2;
    houghCent = unique([houghCent1; houghCent2],'rows');
end
% figure, imshow(houghMap);

angleMap = createAngleMap(colorCent, houghCent, mouth, size(colorMap));
% figure, imshow(angleMap);

distMap = createDistMap(colorCent, houghCent, mouth, size(skinMask));
% figure, imshow(distMap);

% Creates a probability-map from the above methods
eyeMap = (colorMap.*houghMap) + (colorMap.*angleMap.*distMap)/3 + (houghMap.*angleMap.*distMap)/3 + (colorMap+houghMap)/2;
% figure, imshow(eyeMap);

removeBorder = 50;
eyeMap(1:removeBorder,:) = 0;
eyeMap(:,1:removeBorder) = 0;
eyeMap(end-removeBorder:end,:) = 0;
eyeMap(:,end-removeBorder:end) = 0;
% figure, imshow(eyeMap);


[~, num] = bwlabel(eyeMap);
if num < 2
    return
end

u = unique(eyeMap);

% twoEyes takes elements from eyeMap and is constantly updated until likely
% eye-candidates are found
twoEyes = zeros(size(eyeMap));

for i = 0:length(u)-1
        % Marks the highest intensity of eyeMap on twoEyes in decending
        % order
        twoEyes(eyeMap == u(end-i)) = 1;
%         figure, imshow(twoEyes);

        % Finds how many objects there are in twoEyes
        [L, num] = bwlabel(twoEyes);
        
        if num > 1
            P = regionprops(L,'Centroid');
            
            if(P(1).Centroid(1) < P(2).Centroid(1))
                lEye = round(P(1).Centroid);
                rEye = round(P(2).Centroid);
            else
                lEye = round(P(2).Centroid);
            	rEye = round(P(1).Centroid);
            end   
            break
        end
end

% Visualize the result
% if (lEye(1) ~= -1 || rEye(1) ~= -1)
%     figure, imshow(im);
%     viscircles([lEye;rEye;], [12 12]);      % Without mouth
%     viscircles([lEye;rEye;mouth], [12 12 12]); % With mouth
% else
%     fprint('No eyes detected');
% end

end

