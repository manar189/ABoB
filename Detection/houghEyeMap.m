function map = houghEyeMap(im)
%HOUGHCIRCLEMAP Takes an image of a face and returns the image with likely eye
%placements by hough circular transform.
%   Detailed explanation goes here

% i increases sensitivity so more circles are detected
for i = 0.65:0.01:0.95
    [circles, rad] = imfindcircles(im, [6 18], ...
    'ObjectPolarity', 'dark', ...   % dark or bright
    'Method', 'PhaseCode', ...      % PhaseCode or TwoStage
    'Sensitivity', i);            % [0 1]

    if(size(circles,1) > 9)
        break
    end
end


[n, m, ~] = size(im);
map = zeros(n,m);
circles = uint16(circles);

for i = 1:length(rad)
    map(circles(i,2), circles(i,1)) = 1/i;
end

SE = strel('disk', 10);
map = imdilate(map, SE);

figure, imshow(im);
viscircles(circles, rad);
end

