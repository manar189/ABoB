function [lEye,rEye] = detectEyes(im, mouth)
%DETECTEYES Takes an image of a face and returns the positions of the eyes.
%   Detailed explanation goes here

% Difference in distance between eyes and mouth has to be under thresh to
% be counted as same distance
thresh = 20;

% Detecting possible eyes from colormaping
colorMap = colorEyeMap(im, mouth);
% figure, imshow(colorMap);

% Detecting possible eyes from circular hought-ransform
houghMap = houghEyeMap(im, mouth);
% figure, imshow(houghMap);

% Creates a probability-map from the above methods
eyeMap = colorMap.*houghMap + (colorMap+houghMap)/2;
figure, imshow(eyeMap);

% Removing false positives from edge of face
%*******************THIS SHOULD BE IMPROVED*****************
% grayIm = im2gray(im);
% faceMask = zeros(size(grayIm));
% faceMask(grayIm > 0) = 1;
% SE = strel('diamond', 40);
% faceMask = imerode(faceMask, SE);
% eyeMap = eyeMap.*faceMask;
% figure, imshow(eyeMap);

[~, num] = bwlabel(eyeMap);
u = unique(eyeMap);

twoEyes = zeros(size(eyeMap));
% Test if we have found two eyes
if num > 1
    breakLoop = false;
    for i = 0:length(u)-1
        twoEyes(eyeMap == u(end-i)) = 1;
        [L, num] = bwlabel(twoEyes);
        P = regionprops(L,'Centroid');
        if(num > 1)
            % Check if labels are same distance from mouth
            for j=2:num
                % BEHÖVER EN TILL FOR-LOOP
                if (abs(pdist([P(1).Centroid; mouth]) - ...
                    pdist([P(j).Centroid; mouth])) < thresh)
                    fprintf('break');
                    breakLoop = true;
                    break
                elseif j < num
                    for k=j:num-1
                        eyeMap(L == k) = 0;
                        L(L == k) = 0;
                        L(L == k+1) = k;
                    end
                else
                    eyeMap(L == j) = 0;
                end
            end
        end
        if breakLoop
            break
        end
    end
    
    figure, imshow(im + (L == 1) + (L == 2)); % UNCOMMENT THIS TO SEE RESULT

    % Creates the resulting eye-positions from label properties
    P = regionprops(L,'Centroid');
    if(P(1).Centroid(1) < P(2).Centroid(1))
        lEye = uint16(P(1).Centroid);
        rEye = uint16(P(2).Centroid);
    else
        lEye = uint16(P(2).Centroid);
        rEye = uint16(P(1).Centroid);
    end
else
    % Returns -1 which indicates no eyes were found
    lEye = -1;
    rEye = -1;
end
%************************************************************
end

