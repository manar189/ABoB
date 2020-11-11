function map = colorEyeMap(im, mouth)
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
% figure, imshow(eyeMapC);

SE = strel('disk', 10);
eyeMapL = imdilate(Y, SE) ./ (imerode(Y, SE)+1);
% figure, imshow(eyeMapL);

eyeMap = eyeMapC .* eyeMapL;
% figure, imshow(eyeMap);

centerThresh = 20;  % Used to compare centroids to see if they are new
centroids = [];     % Center of a structure
count = 0;          % Limits the number of structures we check
nResult = 11;       % How many centroids should be found before loop breaks
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
            if(P(j).Centroid(2) < mouth(2))
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

goodEyeDist = mouthEyeDist(mouth, centroids);
map = zeros(n,m);
centroids = uint16(centroids);

% Gives a higher value if the earlier the centrod is found
for i = 1:size(centroids,1)
    map(centroids(i,2), centroids(i,1)) = 1/i;
    % Sets points with same dist from mouth to max intensity of the two points 
    for j = 1:length(goodEyeDist)
        if(goodEyeDist(j,1)==i)
            map(centroids(i,2), centroids(i,1)) = ...
                max(map(centroids(goodEyeDist(j,1),2), centroids(goodEyeDist(j,1),1)), ...
                    map(centroids(goodEyeDist(j,2),2), centroids(goodEyeDist(j,2),1))) + 0.2;
        end
    end
end

SE = strel('disk', 13);
map = imdilate(map, SE);

% figure, imshow(im);  
% rad = ones(size(centroids,1),1) * 12;
% viscircles(centroids, rad);
end

