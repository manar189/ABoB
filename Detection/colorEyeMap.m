function [map, centroids] = colorEyeMap(im, mouthPos)
%COLOREYEMAP Takes an image of a face and returns the image with likely eye
%placements by color mapping.
%   Detailed explanation goes here

[n, m, ~] = size(im);
imYCBCR = im2double(rgb2ycbcr(im));

% Create the colormap
Y = imYCBCR(:,:,1);
Cb = imYCBCR(:,:,2);
Cr = imYCBCR(:,:,3);

% Create first map
eyeMapC = 1/3 * (Cb.^2 + (ones(n,m)-Cr).^2 + (Cb./Cr));
% figure, imshow(eyeMapC);

% Makes the nomonator a bit smaller than the denominator to remove bright
% border
SE = strel('disk', 10);
yMask = imbinarize(Y,0.1);
yMask = imdilate(yMask, SE);
SE = strel('disk', 25);
yMask = imerode(yMask, SE);
SE = strel('disk', 8);

% Create second map
eyeMapL = imdilate(Y.*yMask, SE) ./ (imerode(Y, SE)+1);
% figure, imshow(eyeMapL);

% Combindes the maps
eyeMap = eyeMapC .* eyeMapL;
% figure, imshow(eyeMap);

centerThresh = 20;  % Used to compare centroids to see if they are new
centroids = [];     % Center of a structure
count = 0;          % Limits the number of structures we check
nResult = 4;        % How many centroids should be found before loop breaks
% i lowers the threshold on the colormap so values further from max gets
% through
for i = 100:-1:2
    % Color threshold
    eyeMask = (eyeMap >= max(eyeMap(:))-(max(eyeMap(:))/i));
    eyeMask = imclose(eyeMask, SE);
%     figure, imshow(eyeMask);
    [L, num] = bwlabel(eyeMask);
    P = regionprops(L,'Centroid');
    
    if(count < nResult)
        % Loops through number of structures
        for j = 1:num
            % Checks if centroid is above mouth
            if(P(j).Centroid(2) < mouthPos(2) || mouthPos(2) == -1)
                % Initialize forst structure
                if(isempty(centroids))
                   centroids(1,:) = [P(j).Centroid(1) P(j).Centroid(2)];
                   count = count + 1;
                elseif(count < nResult)
                   newCenter = true;
                   % Checks if centroid is an old or new structure
                   for k = 1:size(centroids,1)
                       if(norm(centroids(k,:) - [P(j).Centroid(1) P(j).Centroid(2)]) <= centerThresh)
                           centroids(k,:) = [P(j).Centroid(1) P(j).Centroid(2)];
                           newCenter = false;
                           break
                       end
                   end

                   % Create new structure at end of centroids
                   if(newCenter)
                       centroids(end+1,:) = [P(j).Centroid(1) P(j).Centroid(2)];
                       count = count + 1;
                   end
               end
            end
        end
    else
        break
    end
end

map = createEyeMap(centroids, mouthPos, n, m);

% % Visualize the result
% figure, imshow(im);  
% rad = ones(size(centroids,1),1) * 12;
% viscircles(centroids, rad);
end

