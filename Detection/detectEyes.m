function [lEye,rEye] = detectEyes(im, mouth)
%DETECTEYES Takes an image of a face and returns the positions of the eyes.
%   
%   Detailed explanation goes here

% Difference in distance between eyes and mouth has to be under thresh to
% be counted as same distance
thresh = 15;
lEye = -1;
rEye = -1;

% Detecting possible eyes from colormaping
colorMap = colorEyeMap(im, mouth);
% figure, imshow(colorMap);

% Detecting possible eyes from circular hought-ransform
houghMap = houghEyeMap(im, mouth);
% figure, imshow(houghMap);

% Creates a probability-map from the above methods
eyeMap = colorMap.*houghMap + (colorMap+houghMap)/2;
% figure, imshow(eyeMap);


[~, num] = bwlabel(eyeMap);
u = unique(eyeMap);

% twoEyes takes elements from eyeMap and is constantly updated until likely
% eye-candidates are found
twoEyes = zeros(size(eyeMap));

% Saves the coordinates of the best centroid if no "good match" is found
bestCentroidWrongDist = [];

% Test if we have found two or more eyes-candidates. If we do we try to
% find the best match. We asume that the most intense part of colorMap is a
% good eye. This assumption can easily be wrong and might need improvement.
if num > 1
    breakLoop = false;
    shortestFalse = 1000;   % Random large number used in comparison
    
    % Loops throung each unique intensity in eyeMap
    for i = 0:length(u)-1
        % Marks the highest intensity of eyeMap on twoEyes in decending
        % order
        twoEyes(eyeMap == u(end-i)) = 1;
%         figure, imshow(twoEyes);

        % Finds how many objects there are in twoEyes
        [L, num] = bwlabel(twoEyes);
        P = regionprops(L,'Centroid');
        if(num > 1)
            % Check if labels are same distance from mouth
            for j=2:num
                
                % The difference in distance between the j:th centroid and
                % the first centroid.
                distDiff = abs(pdist([P(1).Centroid; mouth]) - ...
                    pdist([P(j).Centroid; mouth]));
                
                % If the first and the j:th centroid are < thresh
                % difference in distance from mouth we asume that the j:th
                % centroid is the correct second eye and break all loops
                if distDiff < thresh
                    breakLoop = true;
                    break
                    
                % Removes eyes that are > thresh difference in distance
                elseif j < num
                    for k=j:num-1  
                        
                        % However, saves the centroid with the shortest
                        % distance if no good match is found
                        if distDiff < shortestFalse
                           shortestFalse = abs(pdist([P(1).Centroid; mouth]) - ...
                                               pdist([P(j).Centroid; mouth]));
                           bestCentroidWrongDist = P(j).Centroid;
                        end
%                         figure, imshow(twoEyes);
                        twoEyes(L == k) = 0;
%                         figure, imshow(twoEyes);
                        L(L == k) = 0;
                        L(L == k+1) = k;
                    end
                else
                    if distDiff < shortestFalse
                           shortestFalse = abs(pdist([P(1).Centroid; mouth]) - ...
                                               pdist([P(j).Centroid; mouth]));
                           bestCentroidWrongDist = P(j).Centroid;
                    end
%                     figure, imshow(twoEyes);
                    twoEyes(L == j) = 0;
%                     figure, imshow(twoEyes);
                end
            end
        end
        if breakLoop
            break
        end
    end
    
    P = regionprops(L,'Centroid');
    
    % Eye positions if NO good match was found
    if length(P) < 2
         if(P(1).Centroid(1) < bestCentroidWrongDist(1))
            lEye = round(P(1).Centroid);
            rEye = round(bestCentroidWrongDist);
         else
            lEye = round(bestCentroidWrongDist);
            rEye = round(P(1).Centroid);
         end
    % Eye positions if a good match was found
    else
        if(P(1).Centroid(1) < P(2).Centroid(1))
            lEye = round(P(1).Centroid);
            rEye = round(P(2).Centroid);
        else
            lEye = round(P(2).Centroid);
            rEye = round(P(1).Centroid);
        end   
    end
end

% Visualize the result
% if (lEye(1) ~= -1 || rEye(1) ~= -1)
%     figure, imshow(im);
%     % viscircles([lEye;rEye;], [12 12]);      % Without mouth
%     viscircles([lEye;rEye;mouth], [12 12 12]); % With mouth
% else
%     fprint('No eyes detected');
% end

end

