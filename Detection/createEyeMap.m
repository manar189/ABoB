function map = createEyeMap(points, mouthPos, sizeX, sizeY)
%CREATEEYEMAP Summary of this function goes here
%   Detailed explanation goes here

map = zeros(sizeX, sizeY);
points = uint16(points);
sizeOfPoint = 8;    % Determines the size each point gets on the map

% Gives a higher value if the earlier the centrod is found
for i = 1:size(points,1)
    
    % Checks if under 45 deg from mouth
% ******MIGHT WANT TOP MOVE THIS CHECK TO THE COLOR/HOUGH FUNCTIONS******
    if(points(i,2) < mouthPos(2)-abs(points(i,1)-mouthPos(1)) && ...
            points(i,2) < mouthPos(2)-abs(mouthPos(1)-points(i,1)))
% ***********************************************************************
        map(points(i,2), points(i,1)) = 1/i;
    end
end

SE = strel('disk', sizeOfPoint);
map = imdilate(map, SE);
end

