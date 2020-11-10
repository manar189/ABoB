function map = colorEyeMap(im)
%COLOREYEMAP Takes an image of a face and returns the image with likely eye
%placements by color mapping.
%   Detailed explanation goes here

[n, m, ~] = size(im);
imYCBCR = im2double(rgb2ycbcr(im));

% Create the colormap
Y = imYCBCR(:,:,1);
Cb = imYCBCR(:,:,2);
Cr = imYCBCR(:,:,3);
eyeMapC = 1/3 * (Cb.^2 + (ones(n,m)-Cr).^2 + (Cb./Cr));

SE = strel('disk', 25);
eyeMapL = imdilate(Y, SE) ./ (imerode(Y, SE)+1);

eyeMap = eyeMapC .* eyeMapL;


centerThresh = 20;  % Used to compare centroids to see if they are new
centroids = [];     % Center of a structure
count = 1;          % Limits the number of structures we check
% i lowers the threshold on the colormap so values further from max gets
% through
for i = 100:-1:2
    % Color threshold
    eyeMask = (eyeMap >= max(eyeMap(:))-(max(eyeMap(:))/i));
    eyeMask = imclose(eyeMask, SE);
%     figure, imshow(eyeMask);
    [L, num] = bwlabel(eyeMask);
    P = regionprops(L,'Centroid');
    
    if(count < 7)
        % Loops through number of structures
        for j = 1:num
           % Initialize forst structure
           if(isempty(centroids))
               centroids(1,:) = [P(j).Centroid(1) P(j).Centroid(2)];
               count = count + 1;
           elseif(count < 7)
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
    else
        break
    end
end

map = zeros(n,m);
centroids = uint16(centroids);

% Gives a higher value if the earlier the centrod is found
for i = 1:size(centroids,1)
    map(centroids(i,2), centroids(i,1)) = 1/i;
end

SE = strel('disk', 20);
map = imdilate(map, SE);

figure, imshow(im);  
rad = ones(6,1) * 12;
viscircles(centroids, rad);
end

