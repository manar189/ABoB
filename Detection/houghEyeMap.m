function [map, circles] = houghEyeMap(im, mouthPos)
%HOUGHCIRCLEMAP Takes an image of a face and returns the image with likely eye
%placements by hough circular transform.
%   Detailed explanation goes here

[n, m, ~] = size(im);
nResult = 4;       % How many centroids should be found before loop breaks
% i increases sensitivity so more circles are detected
for i = 0.6:0.01:0.96
    [circles, ~] = imfindcircles(im2gray(im), [6 18], ...
    'ObjectPolarity', 'dark', ...   % dark or bright, dark means dark cirlce on bright background
    'Method', 'PhaseCode', ...      % PhaseCode or TwoStage
    'Sensitivity', i);              % [0 1], the higher the more circles are found

    % Deletes results under the mouth so they aren't countet towards the
    % result
    if(~isempty(circles) && mouthPos(2) ~= -1)
        circles(circles(:,2) > mouthPos(2),:) = [];
    end
    
    if(size(circles,1) > nResult)
        break
    end
end

map = createEyeMap(circles, mouthPos, n, m);

% % Visualize the result
% figure, imshow(im);
% rad = ones(size(circles,1),1) * 12;
% viscircles(circles, rad);
end

