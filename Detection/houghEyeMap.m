function map = houghEyeMap(im, mouth)
%HOUGHCIRCLEMAP Takes an image of a face and returns the image with likely eye
%placements by hough circular transform.
%   Detailed explanation goes here

% i increases sensitivity so more circles are detected
nResult = 11;       % How many centroids should be found before loop breaks
for i = 0.75:0.01:0.99
    [circles, ~] = imfindcircles(im, [6 18], ...
    'ObjectPolarity', 'dark', ...   % dark or bright
    'Method', 'PhaseCode', ...      % PhaseCode or TwoStage
    'Sensitivity', i);            % [0 1]

    % Deletes results under the mouth
    if(~isempty(circles))
        circles(circles(:,2) > mouth(2),:) = [];
    end
    
    if(size(circles,1) > nResult)
        break
    end
end

goodEyeDist = mouthEyeDist(mouth, circles);
[n, m, ~] = size(im);
map = zeros(n,m);
circles = uint16(circles);

for i = 1:size(circles,1)
    map(circles(i,2), circles(i,1)) = 1/i;
    % Sets points with same dist from mouth to max intensity of the two points 
    for j = 1:length(goodEyeDist)
        if(goodEyeDist(j,1)==i)
            map(circles(i,2), circles(i,1)) = ...
                max(map(circles(goodEyeDist(j,1),2), circles(goodEyeDist(j,1),1)), ...
                    map(circles(goodEyeDist(j,2),2), circles(goodEyeDist(j,2),1))) + 0.2;
        end
    end
end

SE = strel('disk', 12);
map = imdilate(map, SE);

% figure, imshow(im);
% rad = ones(size(circles,1),1) * 12;
% viscircles(circles, rad);
end

