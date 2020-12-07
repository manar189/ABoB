function faceId = tnm034(im)
%TNM034 Matches an input face image against a database of faces.
%   
%   im: Image of unknown face, RGB-image in uint8 format in the
%   range [0,255].
%
%   id: The identity number (integer) of the identified person,
%   i.e. ‘1’, ‘2’,…,‘16’ for the persons belonging to ‘db1’
%   and ‘0’ for all other faces.

% Adds paths to subfolders
addpath(genpath(fileparts('Detection/')));
addpath(genpath(fileparts('Recognition/')));
addpath(genpath(fileparts('Pictures/')));

% Detection
try
normIm = detectFace(im);
catch e
   faceId = 0;
   fprintf('Error: \n%s \n%s \nReturned faceId = 0', e.identifier, e.message);
   return
end
figure, imshow(normIm);

% Classification
faceId = classifyFace(normIm);


end


