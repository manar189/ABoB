function angleMap = createAngleMap(cent1, cent2, mouth, sizeMap)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

angleMap = zeros(sizeMap);
if mouth(2) == -1
   return
end
thresh = pi/20;
sizeOfPoint = 8;    % Determines the size each point gets on the map

centroids = round([cent1; cent2]);

n = size(centroids,1);
angleMatrix = zeros(n);
for i=1:n
    for j=n:-1:i+1
        angle = abs(atan2(centroids(i,2)-centroids(j,2),...
                          centroids(i,1)-centroids(j,1)));
        if centroids(i,1) < centroids(j,1)
           angle = abs(angle-pi);
        end
        if angle<thresh && ((centroids(i,1) < mouth(1) && ...
                             centroids(j,1) > mouth(1)) || ...
                            (centroids(i,1) > mouth(1) && ...
                             centroids(j,1) < mouth(1)))
        
            angleMatrix(i,j) = 0.5;
            angleMatrix(j,i) = 0.5;
        end
    end
end

for i=1:n
    for j=1:n
        
        if angleMatrix(i,j) > 0
            angleMap(round(centroids(i,2)), round(centroids(i,1))) = angleMatrix(i,j);
        end
        
    end
end

SE = strel('disk', sizeOfPoint);
angleMap = imdilate(angleMap, SE);
end

