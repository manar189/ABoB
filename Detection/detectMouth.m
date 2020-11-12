function [mouthMask] = detectMouth(inImage)
% DETECTMOUTH en funktoin för att upptäcka ansikten
% Detailed explanation goes here
inImage2 = im2double(inImage);
YCbCrImg = rgb2ycbcr(inImage2);

Cb = YCbCrImg(:,:,2);
Cr = YCbCrImg(:,:,3);

CrDivCb = Cr./Cb;

CrSq = Cr.^2;

n = (1/numel(inImage));

nItalic = 0.95*(n*sum(CrSq))/(n*sum(CrDivCb));

Difference = (CrSq - nItalic*CrDivCb).^2;

MouthMap = CrSq .* Difference;

% %find the max value in the image
% [x, y] = find(ismember(MouthMap, max(MouthMap(:))));
% MouthMap(x, y) = 1.0;
% SE = strel('disk', 5);
% MouthMap = imdilate(MouthMap, SE);

%stretching the image
minIm = min(MouthMap(:));
maxIm = max(MouthMap(:));
MouthMap = (MouthMap-minIm)/(maxIm-minIm);

%MouthMap = MouthMap >= 0.8;

outImage = inImage2 + MouthMap;

mouthMask = MouthMap;

end

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


