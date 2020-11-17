function [mouthMap] = detectMouth(inImage)
% DETECTMOUTH en funktoin f?r att uppt?cka ansikten
% Will take in an image and then mask it in the sense that it should find
% the point in the middle of the mouth

% convert image -> double -> YCbCr color space
inImage2 = im2double(inImage);
yCbCrImg = rgb2ycbcr(inImage2);

% get the respective channels Cb & Cr
cb = yCbCrImg(:,:,2);
cr = yCbCrImg(:,:,3);

% the rest follows the formula in lecture 2 slide 53
crDivWithCb = cr./cb;

crSquared = cr.^2;

% numel = tot elements in inImage, n = 1/n in formula from lecture
n = (1/numel(inImage));

% greek letter eta from the formula in lecture 2
eta = 0.95*(n*sum(crSquared))/(n*sum(crDivWithCb));

difference = (crSquared - eta*crDivWithCb).^2;

mouthMap = crSquared .* difference;

% stretching the image since we get values under 0.048 without stretching
% after stretch the values range between 0-1
minIm = min(mouthMap(:));
maxIm = max(mouthMap(:));
mouthMap = (mouthMap-minIm)/(maxIm-minIm);

end

%% old code
% %find the max value in the image
% [x, y] = find(ismember(MouthMap, max(MouthMap(:))));
% MouthMap(x, y) = 1.0;
% SE = strel('disk', 5);
% MouthMap = imdilate(MouthMap, SE);

%% old code
%MouthMap = MouthMap >= 0.8;

%outImage = inImage2 + MouthMap;

%%
%code to run all in database
% clear
% clc
% clear output
% % Specify the folder where the files live.
% myFolder = 'Pictures\DB1\';
% % Check to make sure that folder actually exists.  Warn user if it doesn't.
% if ~isfolder(myFolder)
%     errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', myFolder);
%     uiwait(warndlg(errorMessage));
%     myFolder = uigetdir(); % Ask for a new one.
%     if myFolder == 0
%          % User clicked Cancel
%          return;
%     end
% end
% % Get a list of all files in the folder with the desired file name pattern.
% filePattern = fullfile(myFolder, '*.jpg'); % Change to whatever pattern you need.
% theFiles = dir(filePattern);
% for k = 1 : length(theFiles)
%     baseFileName = theFiles(k).name;
%     fullFileName = fullfile(theFiles(k).folder, baseFileName);
%     fprintf(1, 'Now reading %s\n', fullFileName);
%     % Now do whatever you want with this file name,
%     % such as reading it in as an image array with imread()
%     imageArray = im2double(imread(fullFileName));
%     mouthIm = detectMouth(imageArray);
%     figure
%     imshow(mouthIm);  % Display image.
%     drawnow; % Force display to update immediately.
% end


