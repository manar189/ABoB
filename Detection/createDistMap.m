function distMap = createDistMap(cent1, cent2, mouth, sizeMap)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Difference in distance between eyes and mouth has to be under thresh to
% be counted as same distance

distMap = zeros(sizeMap);
if mouth(2) == -1
   return
end
thresh = 2;
sizeOfPoint = 8;    % Determines the size each point gets on the map

centroids = round([cent1; cent2]);

n = size(centroids,1);
distMatrix = zeros(n,n);

for i=1:n
    for j=n:-1:i+1
        dist = abs(pdist([centroids(i,:); mouth]) - ...
                    pdist([centroids(j,:); mouth]));
        
        if dist<thresh && ((centroids(i,1) < mouth(1) && ...
                            centroids(j,1) > mouth(1)) || ...
                           (centroids(i,1) > mouth(1) && ...
                            centroids(j,1) < mouth(1)))
  
            distMatrix(i,j) = 1/max(dist,0.1);
            distMatrix(j,i) = 1/max(dist,0.1);
        end
    end
end

if any(distMatrix, 'all')
    distMatrix = distMatrix - min(distMatrix(:));
    distMatrix = distMatrix ./ max(distMatrix(:));
end

for i=1:n
    for j=1:n
        
        if distMatrix(i,j) > 0
            distMap(round(centroids(i,2)), round(centroids(i,1))) = distMatrix(i,j);
        end
        
    end
end

SE = strel('disk', sizeOfPoint);
distMap = imdilate(distMap, SE);

end

